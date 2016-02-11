//===-- X86OptimizeLEAs.cpp - optimize usage of LEA instructions ----------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the pass that performs some optimizations with LEA
// instructions in order to improve code size.
// Currently, it does two things:
// 1) If there are two LEA instructions calculating addresses which only differ
//    by displacement inside a basic block, one of them is removed.
// 2) Address calculations in load and store instructions are replaced by
//    existing LEA def registers where possible.
//
//===----------------------------------------------------------------------===//

#include "X86.h"
#include "X86InstrInfo.h"
#include "X86Subtarget.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/LiveVariables.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetInstrInfo.h"

using namespace llvm;

#define DEBUG_TYPE "x86-optimize-LEAs"

static cl::opt<bool>
    DisableX86LEAOpt("disable-x86-lea-opt", cl::Hidden,
                     cl::desc("X86: Disable LEA optimizations."),
                     cl::init(false));

STATISTIC(NumSubstLEAs, "Number of LEA instruction substitutions");
STATISTIC(NumRedundantLEAs, "Number of redundant LEA instructions removed");

class MemOpKey;

/// \brief Returns a hash table key based on memory operands of \p MI. The
/// number of the first memory operand of \p MI is specified through \p N.
static inline MemOpKey getMemOpKey(const MachineInstr &MI, unsigned N);

/// \brief Returns true if two machine operands are identical and they are not
/// physical registers.
static inline bool isIdenticalOp(const MachineOperand &MO1,
                                 const MachineOperand &MO2);

/// \brief Returns true if the instruction is LEA.
static inline bool isLEA(const MachineInstr &MI);

/// A key based on instruction's memory operands.
class MemOpKey {
public:
  MemOpKey(const MachineOperand *Base, const MachineOperand *Scale,
           const MachineOperand *Index, const MachineOperand *Segment,
           const MachineOperand *Disp)
      : Disp(Disp) {
    Operands[0] = Base;
    Operands[1] = Scale;
    Operands[2] = Index;
    Operands[3] = Segment;
  }

  bool operator==(const MemOpKey &Other) const {
    // Addresses' bases, scales, indices and segments must be identical.
    for (int i = 0; i < 4; ++i)
      if (!isIdenticalOp(*Operands[i], *Other.Operands[i]))
        return false;

    assert((Disp->isImm() || Disp->isGlobal()) &&
           (Other.Disp->isImm() || Other.Disp->isGlobal()) &&
           "Address displacement operand is always an immediate or a global");

    // Addresses' displacements must be either immediates or the same global.
    // Immediates' and offsets' values don't matter for the operator since the
    // difference will be taken care of during instruction substitution.
    if ((Disp->isImm() && Other.Disp->isImm()) ||
        (Disp->isGlobal() && Other.Disp->isGlobal() &&
         Disp->getGlobal() == Other.Disp->getGlobal()))
      return true;

    return false;
  }

  // Address' base, scale, index and segment operands.
  const MachineOperand *Operands[4];

  // Address' displacement operand.
  const MachineOperand *Disp;
};

/// Provide DenseMapInfo for MemOpKey.
namespace llvm {
template <> struct DenseMapInfo<MemOpKey> {
  typedef DenseMapInfo<const MachineOperand *> PtrInfo;

  static inline MemOpKey getEmptyKey() {
    return MemOpKey(PtrInfo::getEmptyKey(), PtrInfo::getEmptyKey(),
                    PtrInfo::getEmptyKey(), PtrInfo::getEmptyKey(),
                    PtrInfo::getEmptyKey());
  }

  static inline MemOpKey getTombstoneKey() {
    return MemOpKey(PtrInfo::getTombstoneKey(), PtrInfo::getTombstoneKey(),
                    PtrInfo::getTombstoneKey(), PtrInfo::getTombstoneKey(),
                    PtrInfo::getTombstoneKey());
  }

  static unsigned getHashValue(const MemOpKey &Val) {
    // Checking any field of MemOpKey is enough to determine if the key is
    // empty or tombstone.
    assert(Val.Disp != PtrInfo::getEmptyKey() && "Cannot hash the empty key");
    assert(Val.Disp != PtrInfo::getTombstoneKey() &&
           "Cannot hash the tombstone key");

    hash_code Hash = hash_combine(*Val.Operands[0], *Val.Operands[1],
                                  *Val.Operands[2], *Val.Operands[3]);

    // If the address displacement is an immediate, it should not affect the
    // hash so that memory operands which differ only be immediate displacement
    // would have the same hash. If the address displacement is a global, we
    // should reflect this global in the hash.
    if (Val.Disp->isGlobal())
      Hash = hash_combine(Hash, Val.Disp->getGlobal());

    return (unsigned)Hash;
  }

  static bool isEqual(const MemOpKey &LHS, const MemOpKey &RHS) {
    // Checking any field of MemOpKey is enough to determine if the key is
    // empty or tombstone.
    if (RHS.Disp == PtrInfo::getEmptyKey())
      return LHS.Disp == PtrInfo::getEmptyKey();
    if (RHS.Disp == PtrInfo::getTombstoneKey())
      return LHS.Disp == PtrInfo::getTombstoneKey();
    return LHS == RHS;
  }
};
}

static inline MemOpKey getMemOpKey(const MachineInstr &MI, unsigned N) {
  assert((isLEA(MI) || MI.mayLoadOrStore()) &&
         "The instruction must be a LEA, a load or a store");
  return MemOpKey(&MI.getOperand(N + X86::AddrBaseReg),
                  &MI.getOperand(N + X86::AddrScaleAmt),
                  &MI.getOperand(N + X86::AddrIndexReg),
                  &MI.getOperand(N + X86::AddrSegmentReg),
                  &MI.getOperand(N + X86::AddrDisp));
}

static inline bool isIdenticalOp(const MachineOperand &MO1,
                                 const MachineOperand &MO2) {
  return MO1.isIdenticalTo(MO2) &&
         (!MO1.isReg() ||
          !TargetRegisterInfo::isPhysicalRegister(MO1.getReg()));
}

static inline bool isLEA(const MachineInstr &MI) {
  unsigned Opcode = MI.getOpcode();
  return Opcode == X86::LEA16r || Opcode == X86::LEA32r ||
         Opcode == X86::LEA64r || Opcode == X86::LEA64_32r;
}

namespace {
class OptimizeLEAPass : public MachineFunctionPass {
public:
  OptimizeLEAPass() : MachineFunctionPass(ID) {}

  const char *getPassName() const override { return "X86 LEA Optimize"; }

  /// \brief Loop over all of the basic blocks, replacing address
  /// calculations in load and store instructions, if it's already
  /// been calculated by LEA. Also, remove redundant LEAs.
  bool runOnMachineFunction(MachineFunction &MF) override;

private:
  typedef DenseMap<MemOpKey, SmallVector<MachineInstr *, 16>> MemOpMap;

  /// \brief Returns a distance between two instructions inside one basic block.
  /// Negative result means, that instructions occur in reverse order.
  int calcInstrDist(const MachineInstr &First, const MachineInstr &Last);

  /// \brief Choose the best \p LEA instruction from the \p List to replace
  /// address calculation in \p MI instruction. Return the address displacement
  /// and the distance between \p MI and the choosen \p BestLEA in
  /// \p AddrDispShift and \p Dist.
  bool chooseBestLEA(const SmallVectorImpl<MachineInstr *> &List,
                     const MachineInstr &MI, MachineInstr *&BestLEA,
                     int64_t &AddrDispShift, int &Dist);

  /// \brief Returns the difference between addresses' displacements of \p MI1
  /// and \p MI2. The numbers of the first memory operands for the instructions
  /// are specified through \p N1 and \p N2.
  int64_t getAddrDispShift(const MachineInstr &MI1, unsigned N1,
                           const MachineInstr &MI2, unsigned N2) const;

  /// \brief Returns true if the \p Last LEA instruction can be replaced by the
  /// \p First. The difference between displacements of the addresses calculated
  /// by these LEAs is returned in \p AddrDispShift. It'll be used for proper
  /// replacement of the \p Last LEA's uses with the \p First's def register.
  bool isReplaceable(const MachineInstr &First, const MachineInstr &Last,
                     int64_t &AddrDispShift) const;

  /// \brief Find all LEA instructions in the basic block. Also, assign position
  /// numbers to all instructions in the basic block to speed up calculation of
  /// distance between them.
  void findLEAs(const MachineBasicBlock &MBB, MemOpMap &LEAs);

  /// \brief Removes redundant address calculations.
  bool removeRedundantAddrCalc(MemOpMap &LEAs);

  /// \brief Removes LEAs which calculate similar addresses.
  bool removeRedundantLEAs(MemOpMap &LEAs);

  DenseMap<const MachineInstr *, unsigned> InstrPos;

  MachineRegisterInfo *MRI;
  const X86InstrInfo *TII;
  const X86RegisterInfo *TRI;

  static char ID;
};
char OptimizeLEAPass::ID = 0;
}

FunctionPass *llvm::createX86OptimizeLEAs() { return new OptimizeLEAPass(); }

int OptimizeLEAPass::calcInstrDist(const MachineInstr &First,
                                   const MachineInstr &Last) {
  // Both instructions must be in the same basic block and they must be
  // presented in InstrPos.
  assert(Last.getParent() == First.getParent() &&
         "Instructions are in different basic blocks");
  assert(InstrPos.find(&First) != InstrPos.end() &&
         InstrPos.find(&Last) != InstrPos.end() &&
         "Instructions' positions are undefined");

  return InstrPos[&Last] - InstrPos[&First];
}

// Find the best LEA instruction in the List to replace address recalculation in
// MI. Such LEA must meet these requirements:
// 1) The address calculated by the LEA differs only by the displacement from
//    the address used in MI.
// 2) The register class of the definition of the LEA is compatible with the
//    register class of the address base register of MI.
// 3) Displacement of the new memory operand should fit in 1 byte if possible.
// 4) The LEA should be as close to MI as possible, and prior to it if
//    possible.
bool OptimizeLEAPass::chooseBestLEA(const SmallVectorImpl<MachineInstr *> &List,
                                    const MachineInstr &MI,
                                    MachineInstr *&BestLEA,
                                    int64_t &AddrDispShift, int &Dist) {
  const MachineFunction *MF = MI.getParent()->getParent();
  const MCInstrDesc &Desc = MI.getDesc();
  int MemOpNo = X86II::getMemoryOperandNo(Desc.TSFlags, MI.getOpcode()) +
                X86II::getOperandBias(Desc);

  BestLEA = nullptr;

  // Loop over all LEA instructions.
  for (auto DefMI : List) {
    // Get new address displacement.
    int64_t AddrDispShiftTemp = getAddrDispShift(MI, MemOpNo, *DefMI, 1);

    // Make sure address displacement fits 4 bytes.
    if (!isInt<32>(AddrDispShiftTemp))
      continue;

    // Check that LEA def register can be used as MI address base. Some
    // instructions can use a limited set of registers as address base, for
    // example MOV8mr_NOREX. We could constrain the register class of the LEA
    // def to suit MI, however since this case is very rare and hard to
    // reproduce in a test it's just more reliable to skip the LEA.
    if (TII->getRegClass(Desc, MemOpNo + X86::AddrBaseReg, TRI, *MF) !=
        MRI->getRegClass(DefMI->getOperand(0).getReg()))
      continue;

    // Choose the closest LEA instruction from the list, prior to MI if
    // possible. Note that we took into account resulting address displacement
    // as well. Also note that the list is sorted by the order in which the LEAs
    // occur, so the break condition is pretty simple.
    int DistTemp = calcInstrDist(*DefMI, MI);
    assert(DistTemp != 0 &&
           "The distance between two different instructions cannot be zero");
    if (DistTemp > 0 || BestLEA == nullptr) {
      // Do not update return LEA, if the current one provides a displacement
      // which fits in 1 byte, while the new candidate does not.
      if (BestLEA != nullptr && !isInt<8>(AddrDispShiftTemp) &&
          isInt<8>(AddrDispShift))
        continue;

      BestLEA = DefMI;
      AddrDispShift = AddrDispShiftTemp;
      Dist = DistTemp;
    }

    // FIXME: Maybe we should not always stop at the first LEA after MI.
    if (DistTemp < 0)
      break;
  }

  return BestLEA != nullptr;
}

// Get the difference between the addresses' displacements of the two
// instructions \p MI1 and \p MI2. The numbers of the first memory operands are
// passed through \p N1 and \p N2.
int64_t OptimizeLEAPass::getAddrDispShift(const MachineInstr &MI1, unsigned N1,
                                          const MachineInstr &MI2,
                                          unsigned N2) const {
  // Address displacement operands may differ by a constant.
  const MachineOperand &Op1 = MI1.getOperand(N1 + X86::AddrDisp);
  const MachineOperand &Op2 = MI2.getOperand(N2 + X86::AddrDisp);
  if (Op1.isImm() && Op2.isImm())
    return Op1.getImm() - Op2.getImm();
  else if (Op1.isGlobal() && Op2.isGlobal() &&
           Op1.getGlobal() == Op2.getGlobal())
    return Op1.getOffset() - Op2.getOffset();
  else
    llvm_unreachable("Invalid address displacement operand");
}

// Check that the Last LEA can be replaced by the First LEA. To be so,
// these requirements must be met:
// 1) Addresses calculated by LEAs differ only by displacement.
// 2) Def registers of LEAs belong to the same class.
// 3) All uses of the Last LEA def register are replaceable, thus the
//    register is used only as address base.
bool OptimizeLEAPass::isReplaceable(const MachineInstr &First,
                                    const MachineInstr &Last,
                                    int64_t &AddrDispShift) const {
  assert(isLEA(First) && isLEA(Last) &&
         "The function works only with LEA instructions");

  // Get new address displacement.
  AddrDispShift = getAddrDispShift(Last, 1, First, 1);

  // Make sure that LEA def registers belong to the same class. There may be
  // instructions (like MOV8mr_NOREX) which allow a limited set of registers to
  // be used as their operands, so we must be sure that replacing one LEA
  // with another won't lead to putting a wrong register in the instruction.
  if (MRI->getRegClass(First.getOperand(0).getReg()) !=
      MRI->getRegClass(Last.getOperand(0).getReg()))
    return false;

  // Loop over all uses of the Last LEA to check that its def register is
  // used only as address base for memory accesses. If so, it can be
  // replaced, otherwise - no.
  for (auto &MO : MRI->use_operands(Last.getOperand(0).getReg())) {
    MachineInstr &MI = *MO.getParent();

    // Get the number of the first memory operand.
    const MCInstrDesc &Desc = MI.getDesc();
    int MemOpNo = X86II::getMemoryOperandNo(Desc.TSFlags, MI.getOpcode());

    // If the use instruction has no memory operand - the LEA is not
    // replaceable.
    if (MemOpNo < 0)
      return false;

    MemOpNo += X86II::getOperandBias(Desc);

    // If the address base of the use instruction is not the LEA def register -
    // the LEA is not replaceable.
    if (!isIdenticalOp(MI.getOperand(MemOpNo + X86::AddrBaseReg), MO))
      return false;

    // If the LEA def register is used as any other operand of the use
    // instruction - the LEA is not replaceable.
    for (unsigned i = 0; i < MI.getNumOperands(); i++)
      if (i != (unsigned)(MemOpNo + X86::AddrBaseReg) &&
          isIdenticalOp(MI.getOperand(i), MO))
        return false;

    // Check that the new address displacement will fit 4 bytes.
    if (MI.getOperand(MemOpNo + X86::AddrDisp).isImm() &&
        !isInt<32>(MI.getOperand(MemOpNo + X86::AddrDisp).getImm() +
                   AddrDispShift))
      return false;
  }

  return true;
}

void OptimizeLEAPass::findLEAs(const MachineBasicBlock &MBB, MemOpMap &LEAs) {
  unsigned Pos = 0;
  for (auto &MI : MBB) {
    // Assign the position number to the instruction. Note that we are going to
    // move some instructions during the optimization however there will never
    // be a need to move two instructions before any selected instruction. So to
    // avoid multiple positions' updates during moves we just increase position
    // counter by two leaving a free space for instructions which will be moved.
    InstrPos[&MI] = Pos += 2;

    if (isLEA(MI))
      LEAs[getMemOpKey(MI, 1)].push_back(const_cast<MachineInstr *>(&MI));
  }
}

// Try to find load and store instructions which recalculate addresses already
// calculated by some LEA and replace their memory operands with its def
// register.
bool OptimizeLEAPass::removeRedundantAddrCalc(MemOpMap &LEAs) {
  bool Changed = false;

  assert(!LEAs.empty());
  MachineBasicBlock *MBB = (*LEAs.begin()->second.begin())->getParent();

  // Process all instructions in basic block.
  for (auto I = MBB->begin(), E = MBB->end(); I != E;) {
    MachineInstr &MI = *I++;
    unsigned Opcode = MI.getOpcode();

    // Instruction must be load or store.
    if (!MI.mayLoadOrStore())
      continue;

    // Get the number of the first memory operand.
    const MCInstrDesc &Desc = MI.getDesc();
    int MemOpNo = X86II::getMemoryOperandNo(Desc.TSFlags, Opcode);

    // If instruction has no memory operand - skip it.
    if (MemOpNo < 0)
      continue;

    MemOpNo += X86II::getOperandBias(Desc);

    // Get the best LEA instruction to replace address calculation.
    MachineInstr *DefMI;
    int64_t AddrDispShift;
    int Dist;
    if (!chooseBestLEA(LEAs[getMemOpKey(MI, MemOpNo)], MI, DefMI, AddrDispShift,
                       Dist))
      continue;

    // If LEA occurs before current instruction, we can freely replace
    // the instruction. If LEA occurs after, we can lift LEA above the
    // instruction and this way to be able to replace it. Since LEA and the
    // instruction have similar memory operands (thus, the same def
    // instructions for these operands), we can always do that, without
    // worries of using registers before their defs.
    if (Dist < 0) {
      DefMI->removeFromParent();
      MBB->insert(MachineBasicBlock::iterator(&MI), DefMI);
      InstrPos[DefMI] = InstrPos[&MI] - 1;

      // Make sure the instructions' position numbers are sane.
      assert(((InstrPos[DefMI] == 1 && DefMI == MBB->begin()) ||
              InstrPos[DefMI] >
                  InstrPos[std::prev(MachineBasicBlock::iterator(DefMI))]) &&
             "Instruction positioning is broken");
    }

    // Since we can possibly extend register lifetime, clear kill flags.
    MRI->clearKillFlags(DefMI->getOperand(0).getReg());

    ++NumSubstLEAs;
    DEBUG(dbgs() << "OptimizeLEAs: Candidate to replace: "; MI.dump(););

    // Change instruction operands.
    MI.getOperand(MemOpNo + X86::AddrBaseReg)
        .ChangeToRegister(DefMI->getOperand(0).getReg(), false);
    MI.getOperand(MemOpNo + X86::AddrScaleAmt).ChangeToImmediate(1);
    MI.getOperand(MemOpNo + X86::AddrIndexReg)
        .ChangeToRegister(X86::NoRegister, false);
    MI.getOperand(MemOpNo + X86::AddrDisp).ChangeToImmediate(AddrDispShift);
    MI.getOperand(MemOpNo + X86::AddrSegmentReg)
        .ChangeToRegister(X86::NoRegister, false);

    DEBUG(dbgs() << "OptimizeLEAs: Replaced by: "; MI.dump(););

    Changed = true;
  }

  return Changed;
}

// Try to find similar LEAs in the list and replace one with another.
bool OptimizeLEAPass::removeRedundantLEAs(MemOpMap &LEAs) {
  bool Changed = false;

  // Loop over all entries in the table.
  for (auto &E : LEAs) {
    auto &List = E.second;

    // Loop over all LEA pairs.
    auto I1 = List.begin();
    while (I1 != List.end()) {
      MachineInstr &First = **I1;
      auto I2 = std::next(I1);
      while (I2 != List.end()) {
        MachineInstr &Last = **I2;
        int64_t AddrDispShift;

        // LEAs should be in occurence order in the list, so we can freely
        // replace later LEAs with earlier ones.
        assert(calcInstrDist(First, Last) > 0 &&
               "LEAs must be in occurence order in the list");

        // Check that the Last LEA instruction can be replaced by the First.
        if (!isReplaceable(First, Last, AddrDispShift)) {
          ++I2;
          continue;
        }

        // Loop over all uses of the Last LEA and update their operands. Note
        // that the correctness of this has already been checked in the
        // isReplaceable function.
        for (auto UI = MRI->use_begin(Last.getOperand(0).getReg()),
                  UE = MRI->use_end();
             UI != UE;) {
          MachineOperand &MO = *UI++;
          MachineInstr &MI = *MO.getParent();

          // Get the number of the first memory operand.
          const MCInstrDesc &Desc = MI.getDesc();
          int MemOpNo =
              X86II::getMemoryOperandNo(Desc.TSFlags, MI.getOpcode()) +
              X86II::getOperandBias(Desc);

          // Update address base.
          MO.setReg(First.getOperand(0).getReg());

          // Update address disp.
          MachineOperand *Op = &MI.getOperand(MemOpNo + X86::AddrDisp);
          if (Op->isImm())
            Op->setImm(Op->getImm() + AddrDispShift);
          else if (Op->isGlobal())
            Op->setOffset(Op->getOffset() + AddrDispShift);
          else
            llvm_unreachable("Invalid address displacement operand");
        }

        // Since we can possibly extend register lifetime, clear kill flags.
        MRI->clearKillFlags(First.getOperand(0).getReg());

        ++NumRedundantLEAs;
        DEBUG(dbgs() << "OptimizeLEAs: Remove redundant LEA: "; Last.dump(););

        // By this moment, all of the Last LEA's uses must be replaced. So we
        // can freely remove it.
        assert(MRI->use_empty(Last.getOperand(0).getReg()) &&
               "The LEA's def register must have no uses");
        Last.eraseFromParent();

        // Erase removed LEA from the list.
        I2 = List.erase(I2);

        Changed = true;
      }
      ++I1;
    }
  }

  return Changed;
}

bool OptimizeLEAPass::runOnMachineFunction(MachineFunction &MF) {
  bool Changed = false;

  // Perform this optimization only if we care about code size.
  if (DisableX86LEAOpt || !MF.getFunction()->optForSize())
    return false;

  MRI = &MF.getRegInfo();
  TII = MF.getSubtarget<X86Subtarget>().getInstrInfo();
  TRI = MF.getSubtarget<X86Subtarget>().getRegisterInfo();

  // Process all basic blocks.
  for (auto &MBB : MF) {
    MemOpMap LEAs;
    InstrPos.clear();

    // Find all LEA instructions in basic block.
    findLEAs(MBB, LEAs);

    // If current basic block has no LEAs, move on to the next one.
    if (LEAs.empty())
      continue;

    // Remove redundant LEA instructions. The optimization may have a negative
    // effect on performance, so do it only for -Oz.
    if (MF.getFunction()->optForMinSize())
      Changed |= removeRedundantLEAs(LEAs);

    // Remove redundant address calculations.
    Changed |= removeRedundantAddrCalc(LEAs);
  }

  return Changed;
}
