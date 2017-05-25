//===- llvm/unittest/DebugInfo/CodeView/TypeIndexDiscoveryTest.cpp --------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DebugInfo/CodeView/TypeIndexDiscovery.h"

#include "ErrorChecking.h"
#include "llvm/DebugInfo/CodeView/TypeTableBuilder.h"
#include "llvm/Support/Allocator.h"

#include "gmock/gmock.h"
#include "gtest/gtest.h"

using namespace llvm;
using namespace llvm::codeview;

class TypeIndexIteratorTest : public testing::Test {
public:
  TypeIndexIteratorTest() {}

  void SetUp() override {
    Refs.clear();
    TTB = make_unique<TypeTableBuilder>(Storage);
    FLRB = make_unique<FieldListRecordBuilder>(*TTB);
  }

  void TearDown() override {
    FLRB.reset();
    TTB.reset();
  }

protected:
  template <typename... Indices>
  bool checkTypeReferences(uint32_t RecordIndex, Indices &&... TIs) const {
    EXPECT_EQ(sizeof...(Indices), countRefs(RecordIndex));
    return checkTypeReferencesImpl(RecordIndex, std::forward<Indices>(TIs)...);
  }

  template <typename... T> void writeFieldList(T &&... MemberRecords) {
    FLRB->begin();
    writeFieldListImpl(std::forward<T>(MemberRecords)...);
    FLRB->end(true);
    ASSERT_EQ(1u, TTB->records().size());
    discoverAllTypeIndices();
  }

  template <typename... T> void writeTypeRecords(T &&... Records) {
    writeTypeRecordsImpl(std::forward<T>(Records)...);
    ASSERT_EQ(sizeof...(T), TTB->records().size());
    discoverAllTypeIndices();
  }

  std::unique_ptr<TypeTableBuilder> TTB;

private:
  uint32_t countRefs(uint32_t RecordIndex) const {
    auto &R = Refs[RecordIndex];
    uint32_t Count = 0;
    for (auto &Ref : R) {
      Count += Ref.Count;
    }
    return Count;
  }

  bool checkOneTypeReference(uint32_t RecordIndex, ArrayRef<uint8_t> RecordData,
                             TypeIndex TI) const {
    RecordData = RecordData.drop_front(sizeof(RecordPrefix));
    auto &RefList = Refs[RecordIndex];
    for (auto &Ref : RefList) {
      uint32_t Offset = Ref.Offset;
      ArrayRef<uint8_t> Loc = RecordData.drop_front(Offset);
      ArrayRef<TypeIndex> Indices(
          reinterpret_cast<const TypeIndex *>(Loc.data()), Ref.Count);
      if (llvm::any_of(Indices,
                       [TI](const TypeIndex &Other) { return Other == TI; }))
        return true;
    }
    return false;
  }

  template <typename... Indices>
  bool checkTypeReferencesImpl(uint32_t RecordIndex) const {
    return true;
  }

  template <typename... Indices>
  bool checkTypeReferencesImpl(uint32_t RecordIndex, TypeIndex TI,
                               Indices &&... Rest) const {
    ArrayRef<uint8_t> Record = TTB->records()[RecordIndex];
    bool Success = checkOneTypeReference(RecordIndex, Record, TI);
    EXPECT_TRUE(Success);
    return Success &
           checkTypeReferencesImpl(RecordIndex, std::forward<Indices>(Rest)...);
  }

  void discoverAllTypeIndices() {
    Refs.resize(TTB->records().size());
    for (uint32_t I = 0; I < TTB->records().size(); ++I) {
      ArrayRef<uint8_t> Data = TTB->records()[I];
      discoverTypeIndices(Data, Refs[I]);
    }
  }

  // Helper function to write out a field list record with the given list
  // of member records.
  void writeFieldListImpl() {}

  template <typename RecType, typename... Rest>
  void writeFieldListImpl(RecType &&Record, Rest &&... Records) {
    FLRB->writeMemberType(Record);
    writeFieldListImpl(std::forward<Rest>(Records)...);
  }

  // Helper function to write out a list of type records.
  void writeTypeRecordsImpl() {}

  template <typename RecType, typename... Rest>
  void writeTypeRecordsImpl(RecType &&Record, Rest &&... Records) {
    TTB->writeKnownType(Record);
    writeTypeRecordsImpl(std::forward<Rest>(Records)...);
  }

  std::vector<SmallVector<TiReference, 4>> Refs;
  std::unique_ptr<FieldListRecordBuilder> FLRB;
  BumpPtrAllocator Storage;
};

namespace leafs {
static FuncIdRecord FuncId(TypeIndex(1), TypeIndex(2), "FuncId");
static MemberFuncIdRecord MemFuncId(TypeIndex(3), TypeIndex(4), "FuncId");
static StringIdRecord StringId(TypeIndex(5), "TheString");
static struct {
  std::vector<TypeIndex> Ids = {TypeIndex(6), TypeIndex(7), TypeIndex(8)};
  StringListRecord Record{TypeRecordKind::StringList, Ids};
} StringList;
static struct {
  std::vector<TypeIndex> Ids = {TypeIndex(9), TypeIndex(10), TypeIndex(11)};
  BuildInfoRecord Record{Ids};
} BuildInfo;
static UdtSourceLineRecord UdtSourceLine(TypeIndex(12), TypeIndex(13), 0);
static UdtModSourceLineRecord UdtModSourceLine(TypeIndex(14), TypeIndex(15), 0,
                                               0);
static ModifierRecord Modifier(TypeIndex(16), ModifierOptions::None);
static ProcedureRecord Procedure(TypeIndex(17), CallingConvention::PpcCall,
                                 FunctionOptions::None, 0, TypeIndex(18));
static MemberFunctionRecord MemberFunction(TypeIndex(19), TypeIndex(20),
                                           TypeIndex(21),
                                           CallingConvention::ThisCall,
                                           FunctionOptions::None, 2,
                                           TypeIndex(22), 0);
static struct {
  std::vector<TypeIndex> Ids = {TypeIndex(23), TypeIndex(24), TypeIndex(25)};
  ArgListRecord Record{TypeRecordKind::ArgList, Ids};
} ArgList;
static ArrayRecord Array(TypeIndex(26), TypeIndex(27), 10, "MyArray");
static ClassRecord Class(TypeRecordKind::Class, 3, ClassOptions::None,
                         TypeIndex(28), TypeIndex(29), TypeIndex(30), 10,
                         "MyClass", "MyClassUniqueName");
static ClassRecord Struct(TypeRecordKind::Struct, 3, ClassOptions::None,
                          TypeIndex(31), TypeIndex(32), TypeIndex(33), 10,
                          "MyClass", "MyClassUniqueName");
static UnionRecord Union(1, ClassOptions::None, TypeIndex(34), 10, "MyUnion",
                         "MyUnionUniqueName");
static EnumRecord Enum(1, ClassOptions::None, TypeIndex(35), "MyEnum",
                       "EnumUniqueName", TypeIndex(36));
static BitFieldRecord BitField(TypeIndex(37), 1, 0);
static VFTableRecord VFTable(TypeIndex(38), TypeIndex(39), 1, "VFT", {});
static VFTableShapeRecord VTableShape({});
static struct {
  const TypeIndex T1{40};
  const TypeIndex T2{41};
  const TypeIndex T3{42};
  const TypeIndex T4{43};

  std::vector<OneMethodRecord> Methods{
      {T1, MemberAccess::Public, MethodKind::IntroducingVirtual,
       MethodOptions::None, 0, "Method1"},
      {T2, MemberAccess::Public, MethodKind::PureVirtual, MethodOptions::None,
       0, "Method1"},
      {T3, MemberAccess::Public, MethodKind::PureIntroducingVirtual,
       MethodOptions::None, 0, "Method1"},
      {T4, MemberAccess::Public, MethodKind::Static, MethodOptions::None, 0,
       "Method1"}};

  MethodOverloadListRecord Record{Methods};
} MethodOverloadList;
static PointerRecord Pointer(TypeIndex(44), PointerKind::Near32,
                             PointerMode::Pointer, PointerOptions::Const, 3);
static PointerRecord MemberPointer(
    TypeIndex(45), PointerKind::Near32, PointerMode::PointerToDataMember,
    PointerOptions::Const, 3,
    MemberPointerInfo(TypeIndex(46),
                      PointerToMemberRepresentation::GeneralData));
}

namespace members {
static BaseClassRecord BaseClass(MemberAccess::Public, TypeIndex(47), 0);
static EnumeratorRecord Enumerator(MemberAccess::Public,
                                   APSInt(APInt(8, 3, false)), "Test");
DataMemberRecord DataMember(MemberAccess::Public, TypeIndex(48), 0, "Test");
OverloadedMethodRecord OverloadedMethod(3, TypeIndex(49), "MethodList");
static struct {
  const TypeIndex T1{50};
  const TypeIndex T2{51};
  const TypeIndex T3{52};
  const TypeIndex T4{53};
  OneMethodRecord R1{T1,
                     MemberAccess::Public,
                     MethodKind::IntroducingVirtual,
                     MethodOptions::None,
                     0,
                     "M1"};
  OneMethodRecord R2{T2,
                     MemberAccess::Public,
                     MethodKind::PureVirtual,
                     MethodOptions::None,
                     0,
                     "M2"};
  OneMethodRecord R3{T3,
                     MemberAccess::Public,
                     MethodKind::PureIntroducingVirtual,
                     MethodOptions::None,
                     0,
                     "M3"};
  OneMethodRecord R4{T4,
                     MemberAccess::Protected,
                     MethodKind::Vanilla,
                     MethodOptions::CompilerGenerated,
                     0,
                     "M4"};
} OneMethod;
static NestedTypeRecord NestedType(TypeIndex(54), "MyClass");
static StaticDataMemberRecord StaticDataMember(MemberAccess::Public,
                                               TypeIndex(55), "Foo");
static VirtualBaseClassRecord VirtualBaseClass(TypeRecordKind::VirtualBaseClass,
                                               MemberAccess::Public,
                                               TypeIndex(56), TypeIndex(57), 0,
                                               0);
static VFPtrRecord VFPtr(TypeIndex(58));
static ListContinuationRecord Continuation(TypeIndex(59));
}

TEST_F(TypeIndexIteratorTest, FuncId) {
  using namespace leafs;
  writeTypeRecords(FuncId);
  checkTypeReferences(0, FuncId.FunctionType, FuncId.ParentScope);
}

TEST_F(TypeIndexIteratorTest, MemFuncId) {
  using namespace leafs;
  writeTypeRecords(MemFuncId);
  checkTypeReferences(0, MemFuncId.ClassType, MemFuncId.FunctionType);
}

TEST_F(TypeIndexIteratorTest, StringId) {
  using namespace leafs;
  writeTypeRecords(StringId);
  checkTypeReferences(0, StringId.Id);
}

TEST_F(TypeIndexIteratorTest, SubstrList) {
  using namespace leafs;
  writeTypeRecords(StringList.Record);
  checkTypeReferences(0, StringList.Ids[0], StringList.Ids[1],
                      StringList.Ids[2]);
}

TEST_F(TypeIndexIteratorTest, BuildInfo) {
  using namespace leafs;
  writeTypeRecords(BuildInfo.Record);
  checkTypeReferences(0, BuildInfo.Ids[0], BuildInfo.Ids[1], BuildInfo.Ids[2]);
}

TEST_F(TypeIndexIteratorTest, UdtSrcLine) {
  using namespace leafs;
  writeTypeRecords(UdtSourceLine);
  checkTypeReferences(0, UdtSourceLine.UDT, UdtSourceLine.SourceFile);
}

TEST_F(TypeIndexIteratorTest, UdtModSrcLine) {
  using namespace leafs;
  writeTypeRecords(UdtModSourceLine);
  checkTypeReferences(0, UdtModSourceLine.UDT, UdtModSourceLine.SourceFile);
}

TEST_F(TypeIndexIteratorTest, Modifier) {
  using namespace leafs;
  writeTypeRecords(Modifier);
  checkTypeReferences(0, Modifier.ModifiedType);
}

TEST_F(TypeIndexIteratorTest, Procedure) {
  using namespace leafs;
  writeTypeRecords(Procedure);
  checkTypeReferences(0, Procedure.ReturnType, Procedure.ArgumentList);
}

TEST_F(TypeIndexIteratorTest, MemFunc) {
  using namespace leafs;
  writeTypeRecords(MemberFunction);
  checkTypeReferences(0, MemberFunction.ReturnType, MemberFunction.ClassType,
                      MemberFunction.ThisType, MemberFunction.ArgumentList);
}

TEST_F(TypeIndexIteratorTest, ArgList) {
  using namespace leafs;
  writeTypeRecords(ArgList.Record);
  checkTypeReferences(0, ArgList.Ids[0], ArgList.Ids[1], ArgList.Ids[2]);
}

TEST_F(TypeIndexIteratorTest, Array) {
  using namespace leafs;
  writeTypeRecords(Array);
  checkTypeReferences(0, Array.ElementType, Array.IndexType);
}

TEST_F(TypeIndexIteratorTest, Class) {
  using namespace leafs;
  writeTypeRecords(Class);
  checkTypeReferences(0, Class.FieldList, Class.DerivationList,
                      Class.VTableShape);
}

TEST_F(TypeIndexIteratorTest, Struct) {
  using namespace leafs;
  writeTypeRecords(Struct);
  checkTypeReferences(0, Struct.FieldList, Struct.DerivationList,
                      Struct.VTableShape);
}

TEST_F(TypeIndexIteratorTest, Union) {
  using namespace leafs;
  writeTypeRecords(Union);
  checkTypeReferences(0, Union.FieldList);
}

TEST_F(TypeIndexIteratorTest, Enum) {
  using namespace leafs;
  writeTypeRecords(Enum);
  checkTypeReferences(0, Enum.FieldList, Enum.UnderlyingType);
}

TEST_F(TypeIndexIteratorTest, Bitfield) {
  using namespace leafs;
  writeTypeRecords(BitField);
  checkTypeReferences(0, BitField.Type);
}

TEST_F(TypeIndexIteratorTest, VTable) {
  using namespace leafs;
  writeTypeRecords(VFTable);
  checkTypeReferences(0, VFTable.CompleteClass, VFTable.OverriddenVFTable);
}

TEST_F(TypeIndexIteratorTest, VTShape) {
  using namespace leafs;
  writeTypeRecords(VTableShape);
  checkTypeReferences(0);
}

TEST_F(TypeIndexIteratorTest, OverloadList) {
  using namespace leafs;
  writeTypeRecords(MethodOverloadList.Record);
  checkTypeReferences(0, MethodOverloadList.T1, MethodOverloadList.T2,
                      MethodOverloadList.T3, MethodOverloadList.T4);
}

TEST_F(TypeIndexIteratorTest, Pointer) {
  using namespace leafs;
  writeTypeRecords(Pointer);
  checkTypeReferences(0, Pointer.ReferentType);
}

TEST_F(TypeIndexIteratorTest, MemberPointer) {
  using namespace leafs;
  writeTypeRecords(MemberPointer);
  checkTypeReferences(0, MemberPointer.ReferentType,
                      MemberPointer.MemberInfo->ContainingType);
}

TEST_F(TypeIndexIteratorTest, ManyTypes) {

  using namespace leafs;
  writeTypeRecords(FuncId, MemFuncId, StringId, StringList.Record,
                   BuildInfo.Record, UdtSourceLine, UdtModSourceLine, Modifier,
                   Procedure, MemberFunction, ArgList.Record, Array, Class,
                   Union, Enum, BitField, VFTable, VTableShape,
                   MethodOverloadList.Record, Pointer, MemberPointer);

  checkTypeReferences(0, FuncId.FunctionType, FuncId.ParentScope);
  checkTypeReferences(1, MemFuncId.ClassType, MemFuncId.FunctionType);
  checkTypeReferences(2, StringId.Id);
  checkTypeReferences(3, StringList.Ids[0], StringList.Ids[1],
                      StringList.Ids[2]);
  checkTypeReferences(4, BuildInfo.Ids[0], BuildInfo.Ids[1], BuildInfo.Ids[2]);
  checkTypeReferences(5, UdtSourceLine.UDT, UdtSourceLine.SourceFile);
  checkTypeReferences(6, UdtModSourceLine.UDT, UdtModSourceLine.SourceFile);
  checkTypeReferences(7, Modifier.ModifiedType);
  checkTypeReferences(8, Procedure.ReturnType, Procedure.ArgumentList);
  checkTypeReferences(9, MemberFunction.ReturnType, MemberFunction.ClassType,
                      MemberFunction.ThisType, MemberFunction.ArgumentList);
  checkTypeReferences(10, ArgList.Ids[0], ArgList.Ids[1], ArgList.Ids[2]);
  checkTypeReferences(11, Array.ElementType, Array.IndexType);
  checkTypeReferences(12, Class.FieldList, Class.DerivationList,
                      Class.VTableShape);
  checkTypeReferences(13, Union.FieldList);
  checkTypeReferences(14, Enum.FieldList, Enum.UnderlyingType);
  checkTypeReferences(15, BitField.Type);
  checkTypeReferences(16, VFTable.CompleteClass, VFTable.OverriddenVFTable);
  checkTypeReferences(17);
  checkTypeReferences(18, MethodOverloadList.T1, MethodOverloadList.T2,
                      MethodOverloadList.T3, MethodOverloadList.T4);
  checkTypeReferences(19, Pointer.ReferentType);
  checkTypeReferences(20, MemberPointer.ReferentType,
                      MemberPointer.MemberInfo->ContainingType);
}

TEST_F(TypeIndexIteratorTest, FieldListBaseClass) {
  using namespace members;
  writeFieldList(BaseClass);
  checkTypeReferences(0, BaseClass.Type);
}

TEST_F(TypeIndexIteratorTest, FieldListEnumerator) {
  using namespace members;
  writeFieldList(Enumerator);
  checkTypeReferences(0);
}

TEST_F(TypeIndexIteratorTest, FieldListMember) {
  using namespace members;
  writeFieldList(DataMember);
  checkTypeReferences(0, DataMember.Type);
}

TEST_F(TypeIndexIteratorTest, FieldListMethod) {
  using namespace members;
  writeFieldList(OverloadedMethod);
  checkTypeReferences(0, OverloadedMethod.MethodList);
}

TEST_F(TypeIndexIteratorTest, FieldListOneMethod) {
  using namespace members;
  writeFieldList(OneMethod.R1, OneMethod.R2, OneMethod.R3, OneMethod.R4);
  checkTypeReferences(0, OneMethod.T1, OneMethod.T2, OneMethod.T3,
                      OneMethod.T4);
}

TEST_F(TypeIndexIteratorTest, FieldListNestedType) {
  using namespace members;
  writeFieldList(NestedType);
  checkTypeReferences(0, NestedType.Type);
}

TEST_F(TypeIndexIteratorTest, FieldListStaticMember) {
  using namespace members;
  writeFieldList(StaticDataMember);
  checkTypeReferences(0, StaticDataMember.Type);
}

TEST_F(TypeIndexIteratorTest, FieldListVirtualBase) {
  using namespace members;
  writeFieldList(VirtualBaseClass);
  checkTypeReferences(0, VirtualBaseClass.BaseType, VirtualBaseClass.VBPtrType);
}

TEST_F(TypeIndexIteratorTest, FieldListVFTable) {
  using namespace members;
  writeFieldList(VFPtr);
  checkTypeReferences(0, VFPtr.Type);
}

TEST_F(TypeIndexIteratorTest, FieldListContinuation) {
  using namespace members;
  writeFieldList(Continuation);
  checkTypeReferences(0, Continuation.ContinuationIndex);
}

TEST_F(TypeIndexIteratorTest, ManyMembers) {
  using namespace members;
  writeFieldList(BaseClass, Enumerator, DataMember, OverloadedMethod,
                 OneMethod.R1, OneMethod.R2, OneMethod.R3, OneMethod.R4,
                 NestedType, StaticDataMember, VirtualBaseClass, VFPtr,
                 Continuation);

  checkTypeReferences(
      0, BaseClass.Type, DataMember.Type, OverloadedMethod.MethodList,
      OneMethod.T1, OneMethod.T2, OneMethod.T3, OneMethod.T4, NestedType.Type,
      StaticDataMember.Type, VirtualBaseClass.BaseType,
      VirtualBaseClass.VBPtrType, VFPtr.Type, Continuation.ContinuationIndex);
}