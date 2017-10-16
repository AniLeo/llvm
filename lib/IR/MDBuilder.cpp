//===---- llvm/MDBuilder.cpp - Builder for LLVM metadata ------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the MDBuilder class, which is used as a convenient way to
// create LLVM metadata with a consistent and simplified interface.
//
//===----------------------------------------------------------------------===//

#include "llvm/IR/MDBuilder.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Metadata.h"
using namespace llvm;

MDString *MDBuilder::createString(StringRef Str) {
  return MDString::get(Context, Str);
}

ConstantAsMetadata *MDBuilder::createConstant(Constant *C) {
  return ConstantAsMetadata::get(C);
}

MDNode *MDBuilder::createFPMath(float Accuracy) {
  if (Accuracy == 0.0)
    return nullptr;
  assert(Accuracy > 0.0 && "Invalid fpmath accuracy!");
  auto *Op =
      createConstant(ConstantFP::get(Type::getFloatTy(Context), Accuracy));
  return MDNode::get(Context, Op);
}

MDNode *MDBuilder::createBranchWeights(uint32_t TrueWeight,
                                       uint32_t FalseWeight) {
  return createBranchWeights({TrueWeight, FalseWeight});
}

MDNode *MDBuilder::createBranchWeights(ArrayRef<uint32_t> Weights) {
  assert(Weights.size() >= 1 && "Need at least one branch weights!");

  SmallVector<Metadata *, 4> Vals(Weights.size() + 1);
  Vals[0] = createString("branch_weights");

  Type *Int32Ty = Type::getInt32Ty(Context);
  for (unsigned i = 0, e = Weights.size(); i != e; ++i)
    Vals[i + 1] = createConstant(ConstantInt::get(Int32Ty, Weights[i]));

  return MDNode::get(Context, Vals);
}

MDNode *MDBuilder::createUnpredictable() {
  return MDNode::get(Context, None);
}

MDNode *MDBuilder::createFunctionEntryCount(
    uint64_t Count, const DenseSet<GlobalValue::GUID> *Imports) {
  Type *Int64Ty = Type::getInt64Ty(Context);
  SmallVector<Metadata *, 8> Ops;
  Ops.push_back(createString("function_entry_count"));
  Ops.push_back(createConstant(ConstantInt::get(Int64Ty, Count)));
  if (Imports) {
    SmallVector<GlobalValue::GUID, 2> OrderID(Imports->begin(), Imports->end());
    std::stable_sort(OrderID.begin(), OrderID.end(),
      [] (GlobalValue::GUID A, GlobalValue::GUID B) {
        return A < B;});
    for (auto ID : OrderID)
      Ops.push_back(createConstant(ConstantInt::get(Int64Ty, ID)));
  }
  return MDNode::get(Context, Ops);
}

MDNode *MDBuilder::createFunctionSectionPrefix(StringRef Prefix) {
  return MDNode::get(Context,
                     {createString("function_section_prefix"),
                      createString(Prefix)});
}

MDNode *MDBuilder::createRange(const APInt &Lo, const APInt &Hi) {
  assert(Lo.getBitWidth() == Hi.getBitWidth() && "Mismatched bitwidths!");

  Type *Ty = IntegerType::get(Context, Lo.getBitWidth());
  return createRange(ConstantInt::get(Ty, Lo), ConstantInt::get(Ty, Hi));
}

MDNode *MDBuilder::createRange(Constant *Lo, Constant *Hi) {
  // If the range is everything then it is useless.
  if (Hi == Lo)
    return nullptr;

  // Return the range [Lo, Hi).
  return MDNode::get(Context, {createConstant(Lo), createConstant(Hi)});
}

MDNode *MDBuilder::createCallees(ArrayRef<Function *> Callees) {
  SmallVector<Metadata *, 4> Ops;
  for (Function *F : Callees)
    Ops.push_back(createConstant(F));
  return MDNode::get(Context, Ops);
}

MDNode *MDBuilder::createAnonymousAARoot(StringRef Name, MDNode *Extra) {
  // To ensure uniqueness the root node is self-referential.
  auto Dummy = MDNode::getTemporary(Context, None);

  SmallVector<Metadata *, 3> Args(1, Dummy.get());
  if (Extra)
    Args.push_back(Extra);
  if (!Name.empty())
    Args.push_back(createString(Name));
  MDNode *Root = MDNode::get(Context, Args);

  // At this point we have
  //   !0 = metadata !{}            <- dummy
  //   !1 = metadata !{metadata !0} <- root
  // Replace the dummy operand with the root node itself and delete the dummy.
  Root->replaceOperandWith(0, Root);

  // We now have
  //   !1 = metadata !{metadata !1} <- self-referential root
  return Root;
}

MDNode *MDBuilder::createTBAARoot(StringRef Name) {
  return MDNode::get(Context, createString(Name));
}

/// \brief Return metadata for a non-root TBAA node with the given name,
/// parent in the TBAA tree, and value for 'pointsToConstantMemory'.
MDNode *MDBuilder::createTBAANode(StringRef Name, MDNode *Parent,
                                  bool isConstant) {
  if (isConstant) {
    Constant *Flags = ConstantInt::get(Type::getInt64Ty(Context), 1);
    return MDNode::get(Context,
                       {createString(Name), Parent, createConstant(Flags)});
  }
  return MDNode::get(Context, {createString(Name), Parent});
}

MDNode *MDBuilder::createAliasScopeDomain(StringRef Name) {
  return MDNode::get(Context, createString(Name));
}

MDNode *MDBuilder::createAliasScope(StringRef Name, MDNode *Domain) {
  return MDNode::get(Context, {createString(Name), Domain});
}

/// \brief Return metadata for a tbaa.struct node with the given
/// struct field descriptions.
MDNode *MDBuilder::createTBAAStructNode(ArrayRef<TBAAStructField> Fields) {
  SmallVector<Metadata *, 4> Vals(Fields.size() * 3);
  Type *Int64 = Type::getInt64Ty(Context);
  for (unsigned i = 0, e = Fields.size(); i != e; ++i) {
    Vals[i * 3 + 0] = createConstant(ConstantInt::get(Int64, Fields[i].Offset));
    Vals[i * 3 + 1] = createConstant(ConstantInt::get(Int64, Fields[i].Size));
    Vals[i * 3 + 2] = Fields[i].TBAA;
  }
  return MDNode::get(Context, Vals);
}

/// \brief Return metadata for a TBAA struct node in the type DAG
/// with the given name, a list of pairs (offset, field type in the type DAG).
MDNode *MDBuilder::createTBAAStructTypeNode(
    StringRef Name, ArrayRef<std::pair<MDNode *, uint64_t>> Fields) {
  SmallVector<Metadata *, 4> Ops(Fields.size() * 2 + 1);
  Type *Int64 = Type::getInt64Ty(Context);
  Ops[0] = createString(Name);
  for (unsigned i = 0, e = Fields.size(); i != e; ++i) {
    Ops[i * 2 + 1] = Fields[i].first;
    Ops[i * 2 + 2] = createConstant(ConstantInt::get(Int64, Fields[i].second));
  }
  return MDNode::get(Context, Ops);
}

/// \brief Return metadata for a TBAA scalar type node with the
/// given name, an offset and a parent in the TBAA type DAG.
MDNode *MDBuilder::createTBAAScalarTypeNode(StringRef Name, MDNode *Parent,
                                            uint64_t Offset) {
  ConstantInt *Off = ConstantInt::get(Type::getInt64Ty(Context), Offset);
  return MDNode::get(Context,
                     {createString(Name), Parent, createConstant(Off)});
}

/// \brief Return metadata for a TBAA tag node with the given
/// base type, access type and offset relative to the base type.
MDNode *MDBuilder::createTBAAStructTagNode(MDNode *BaseType, MDNode *AccessType,
                                           uint64_t Offset, bool IsConstant) {
  IntegerType *Int64 = Type::getInt64Ty(Context);
  ConstantInt *Off = ConstantInt::get(Int64, Offset);
  if (IsConstant) {
    return MDNode::get(Context, {BaseType, AccessType, createConstant(Off),
                                 createConstant(ConstantInt::get(Int64, 1))});
  }
  return MDNode::get(Context, {BaseType, AccessType, createConstant(Off)});
}
