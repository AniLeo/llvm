//===-- Writer.cpp - Library for writing LLVM bytecode files --------------===//
// 
//                     The LLVM Compiler Infrastructure
//
// This file was developed by the LLVM research group and is distributed under
// the University of Illinois Open Source License. See LICENSE.TXT for details.
// 
//===----------------------------------------------------------------------===//
//
// This library implements the functionality defined in llvm/Bytecode/Writer.h
//
// Note that this file uses an unusual technique of outputting all the bytecode
// to a deque of unsigned char, then copies the deque to an ostream.  The
// reason for this is that we must do "seeking" in the stream to do back-
// patching, and some very important ostreams that we want to support (like
// pipes) do not support seeking.  :( :( :(
//
// The choice of the deque data structure is influenced by the extremely fast
// "append" speed, plus the free "seek"/replace in the middle of the stream. I
// didn't use a vector because the stream could end up very large and copying
// the whole thing to reallocate would be kinda silly.
//
//===----------------------------------------------------------------------===//

#include "WriterInternals.h"
#include "llvm/Bytecode/WriteBytecodePass.h"
#include "llvm/Constants.h"
#include "llvm/DerivedTypes.h"
#include "llvm/Module.h"
#include "llvm/SymbolTable.h"
#include "Support/STLExtras.h"
#include "Support/Statistic.h"
#include "Support/Debug.h"
#include <cstring>
#include <algorithm>
using namespace llvm;

static RegisterPass<WriteBytecodePass> X("emitbytecode", "Bytecode Writer");

static Statistic<> 
BytesWritten("bytecodewriter", "Number of bytecode bytes written");
static Statistic<> 
ConstantTotalBytes("bytecodewriter", "Bytes of constants total");
static Statistic<> 
FunctionConstantTotalBytes("bytecodewriter", "Bytes of function constants total");
static Statistic<>
ConstantPlaneHeaderBytes("bytecodewriter", "Constant plane header bytes");
static Statistic<> 
InstructionBytes("bytecodewriter", "Bytes of bytes of instructions");
static Statistic<> 
SymTabBytes("bytecodewriter", "Bytes of symbol table");
static Statistic<> 
ModuleInfoBytes("bytecodewriter", "Bytes of module info");

BytecodeWriter::BytecodeWriter(std::deque<unsigned char> &o, const Module *M) 
  : Out(o), Table(M, true) {

  // Emit the signature...
  static const unsigned char *Sig =  (const unsigned char*)"llvm";
  output_data(Sig, Sig+4, Out);

  // Emit the top level CLASS block.
  BytecodeBlock ModuleBlock(BytecodeFormat::Module, Out);

  bool isBigEndian      = M->getEndianness() == Module::BigEndian;
  bool hasLongPointers  = M->getPointerSize() == Module::Pointer64;
  bool hasNoEndianness  = M->getEndianness() == Module::AnyEndianness;
  bool hasNoPointerSize = M->getPointerSize() == Module::AnyPointerSize;

  // Output the version identifier... we are currently on bytecode version #1,
  // which corresponds to LLVM v1.2.
  unsigned Version = (1 << 4) | isBigEndian | (hasLongPointers << 1) |
                     (hasNoEndianness << 2) | (hasNoPointerSize << 3);
  output_vbr(Version, Out);
  align32(Out);

  {
    BytecodeBlock CPool(BytecodeFormat::GlobalTypePlane, Out);
    
    // Write the type plane for types first because earlier planes (e.g. for a
    // primitive type like float) may have constants constructed using types
    // coming later (e.g., via getelementptr from a pointer type).  The type
    // plane is needed before types can be fwd or bkwd referenced.
    const std::vector<const Value*> &Plane = Table.getPlane(Type::TypeTyID);
    assert(!Plane.empty() && "No types at all?");
    unsigned ValNo = Type::FirstDerivedTyID; // Start at the derived types...
    outputConstantsInPlane(Plane, ValNo);      // Write out the types
  }

  DEBUG(for (unsigned i = 0; i != Type::TypeTyID; ++i)
          if (Table.getPlane(i).size())
            std::cerr << "  ModuleLevel["
                      << *Type::getPrimitiveType((Type::PrimitiveID)i)
                      << "] = " << Table.getPlane(i).size() << "\n");

  // The ModuleInfoBlock follows directly after the type information
  outputModuleInfoBlock(M);

  // Output module level constants, used for global variable initializers
  outputConstants(false);

  // Do the whole module now! Process each function at a time...
  for (Module::const_iterator I = M->begin(), E = M->end(); I != E; ++I)
    outputFunction(I);

  // If needed, output the symbol table for the module...
  outputSymbolTable(M->getSymbolTable());
}

// Helper function for outputConstants().
// Writes out all the constants in the plane Plane starting at entry StartNo.
// 
void BytecodeWriter::outputConstantsInPlane(const std::vector<const Value*>
                                            &Plane, unsigned StartNo) {
  unsigned ValNo = StartNo;
  
  // Scan through and ignore function arguments, global values, and constant
  // strings.
  for (; ValNo < Plane.size() &&
         (isa<Argument>(Plane[ValNo]) || isa<GlobalValue>(Plane[ValNo]) ||
          (isa<ConstantArray>(Plane[ValNo]) &&
           cast<ConstantArray>(Plane[ValNo])->isString())); ValNo++)
    /*empty*/;

  unsigned NC = ValNo;              // Number of constants
  for (; NC < Plane.size() && 
         (isa<Constant>(Plane[NC]) || isa<Type>(Plane[NC])); NC++)
    /*empty*/;
  NC -= ValNo;                      // Convert from index into count
  if (NC == 0) return;              // Skip empty type planes...

  // FIXME: Most slabs only have 1 or 2 entries!  We should encode this much
  // more compactly.

  ConstantPlaneHeaderBytes -= Out.size();

  // Output type header: [num entries][type id number]
  //
  output_vbr(NC, Out);

  // Output the Type ID Number...
  int Slot = Table.getSlot(Plane.front()->getType());
  assert (Slot != -1 && "Type in constant pool but not in function!!");
  output_vbr((unsigned)Slot, Out);

  ConstantPlaneHeaderBytes += Out.size();


  //cerr << "Emitting " << NC << " constants of type '" 
  //	 << Plane.front()->getType()->getName() << "' = Slot #" << Slot << "\n";

  for (unsigned i = ValNo; i < ValNo+NC; ++i) {
    const Value *V = Plane[i];
    if (const Constant *CPV = dyn_cast<Constant>(V)) {
      //cerr << "Serializing value: <" << V->getType() << ">: " << V << ":" 
      //     << Out.size() << "\n";
      outputConstant(CPV);
    } else {
      outputType(cast<Type>(V));
    }
  }
}

void BytecodeWriter::outputConstants(bool isFunction) {
  ConstantTotalBytes -= Out.size();
  if (isFunction) FunctionConstantTotalBytes -= Out.size();
  BytecodeBlock CPool(BytecodeFormat::ConstantPool, Out,
                      true  /* Elide block if empty */);

  unsigned NumPlanes = Table.getNumPlanes();

  // Output the type plane before any constants!
  if (isFunction && NumPlanes > Type::TypeTyID) {
    const std::vector<const Value*> &Plane = Table.getPlane(Type::TypeTyID);
    if (!Plane.empty()) {              // Skip empty type planes...
      unsigned ValNo = Table.getModuleLevel(Type::TypeTyID);
      outputConstantsInPlane(Plane, ValNo);
    }
  }
  
  // Output module-level string constants before any other constants.x
  if (!isFunction)
    outputConstantStrings();

  for (unsigned pno = 0; pno != NumPlanes; pno++)
    if (pno != Type::TypeTyID) {         // Type plane handled above.
      const std::vector<const Value*> &Plane = Table.getPlane(pno);
      if (!Plane.empty()) {              // Skip empty type planes...
        unsigned ValNo = 0;
        if (isFunction)                  // Don't re-emit module constants
          ValNo += Table.getModuleLevel(pno);
        
        if (pno >= Type::FirstDerivedTyID) {
          // Skip zero initializer
          if (ValNo == 0)
            ValNo = 1;
        }
        
        // Write out constants in the plane
        outputConstantsInPlane(Plane, ValNo);
      }
    }
  ConstantTotalBytes += Out.size();
  if (isFunction) FunctionConstantTotalBytes += Out.size();
}

static unsigned getEncodedLinkage(const GlobalValue *GV) {
  switch (GV->getLinkage()) {
  default: assert(0 && "Invalid linkage!");
  case GlobalValue::ExternalLinkage:  return 0;
  case GlobalValue::WeakLinkage:      return 1;
  case GlobalValue::AppendingLinkage: return 2;
  case GlobalValue::InternalLinkage:  return 3;
  case GlobalValue::LinkOnceLinkage:  return 4;
  }
}

void BytecodeWriter::outputModuleInfoBlock(const Module *M) {
  ModuleInfoBytes -= Out.size();

  BytecodeBlock ModuleInfoBlock(BytecodeFormat::ModuleGlobalInfo, Out);
  
  // Output the types for the global variables in the module...
  for (Module::const_giterator I = M->gbegin(), End = M->gend(); I != End;++I) {
    int Slot = Table.getSlot(I->getType());
    assert(Slot != -1 && "Module global vars is broken!");

    // Fields: bit0 = isConstant, bit1 = hasInitializer, bit2-4=Linkage,
    // bit5+ = Slot # for type
    unsigned oSlot = ((unsigned)Slot << 5) | (getEncodedLinkage(I) << 2) |
                     (I->hasInitializer() << 1) | I->isConstant();
    output_vbr(oSlot, Out);

    // If we have an initializer, output it now.
    if (I->hasInitializer()) {
      Slot = Table.getSlot((Value*)I->getInitializer());
      assert(Slot != -1 && "No slot for global var initializer!");
      output_vbr((unsigned)Slot, Out);
    }
  }
  output_vbr((unsigned)Table.getSlot(Type::VoidTy), Out);

  // Output the types of the functions in this module...
  for (Module::const_iterator I = M->begin(), End = M->end(); I != End; ++I) {
    int Slot = Table.getSlot(I->getType());
    assert(Slot != -1 && "Module const pool is broken!");
    assert(Slot >= Type::FirstDerivedTyID && "Derived type not in range!");
    output_vbr((unsigned)Slot, Out);
  }
  output_vbr((unsigned)Table.getSlot(Type::VoidTy), Out);

  ModuleInfoBytes += Out.size();
}

void BytecodeWriter::outputFunction(const Function *F) {
  BytecodeBlock FunctionBlock(BytecodeFormat::Function, Out);
  output_vbr(getEncodedLinkage(F), Out);
  // Only output the constant pool and other goodies if needed...
  if (!F->isExternal()) {

    // Get slot information about the function...
    Table.incorporateFunction(F);

    // Output information about the constants in the function...
    outputConstants(true);

    {  // Output all of the instructions in the body of the function
      BytecodeBlock ILBlock(BytecodeFormat::InstructionList, Out);
      InstructionBytes -= Out.size();
      for (Function::const_iterator BB = F->begin(), E = F->end(); BB != E;++BB)
        for(BasicBlock::const_iterator I = BB->begin(), E = BB->end(); I!=E;++I)
          processInstruction(*I);
      InstructionBytes += Out.size();
    }
    
    // If needed, output the symbol table for the function...
    outputSymbolTable(F->getSymbolTable());
    
    Table.purgeFunction();
  }
}

void BytecodeWriter::outputSymbolTable(const SymbolTable &MST) {
  // Do not output the Bytecode block for an empty symbol table, it just wastes
  // space!
  if (MST.begin() == MST.end()) return;

  SymTabBytes -= Out.size();
  
  BytecodeBlock SymTabBlock(BytecodeFormat::SymbolTable, Out,
                            true/* ElideIfEmpty*/);

  for (SymbolTable::const_iterator TI = MST.begin(); TI != MST.end(); ++TI) {
    SymbolTable::type_const_iterator I = MST.type_begin(TI->first);
    SymbolTable::type_const_iterator End = MST.type_end(TI->first);
    int Slot;
    
    if (I == End) continue;  // Don't mess with an absent type...

    // Symtab block header: [num entries][type id number]
    output_vbr(MST.type_size(TI->first), Out);

    Slot = Table.getSlot(TI->first);
    assert(Slot != -1 && "Type in symtab, but not in table!");
    output_vbr((unsigned)Slot, Out);

    for (; I != End; ++I) {
      // Symtab entry: [def slot #][name]
      Slot = Table.getSlot(I->second);
      assert(Slot != -1 && "Value in symtab but has no slot number!!");
      output_vbr((unsigned)Slot, Out);
      output(I->first, Out, false); // Don't force alignment...
    }
  }

  SymTabBytes += Out.size();
}

void llvm::WriteBytecodeToFile(const Module *C, std::ostream &Out) {
  assert(C && "You can't write a null module!!");

  std::deque<unsigned char> Buffer;

  // This object populates buffer for us...
  BytecodeWriter BCW(Buffer, C);

  // Keep track of how much we've written...
  BytesWritten += Buffer.size();

  // Okay, write the deque out to the ostream now... the deque is not
  // sequential in memory, however, so write out as much as possible in big
  // chunks, until we're done.
  //
  std::deque<unsigned char>::const_iterator I = Buffer.begin(),E = Buffer.end();
  while (I != E) {                           // Loop until it's all written
    // Scan to see how big this chunk is...
    const unsigned char *ChunkPtr = &*I;
    const unsigned char *LastPtr = ChunkPtr;
    while (I != E) {
      const unsigned char *ThisPtr = &*++I;
      if (LastPtr+1 != ThisPtr) {   // Advanced by more than a byte of memory?
        ++LastPtr;
        break;
      }
      LastPtr = ThisPtr;
    }
    
    // Write out the chunk...
    Out.write((char*)ChunkPtr, LastPtr-ChunkPtr);
  }

  Out.flush();
}
