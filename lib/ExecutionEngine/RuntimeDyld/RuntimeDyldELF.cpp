//===-- RuntimeDyldELF.cpp - Run-time dynamic linker for MC-JIT -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Implementation of ELF support for the MC-JIT runtime dynamic linker.
//
//===----------------------------------------------------------------------===//

#include "RuntimeDyldELF.h"
#include "RuntimeDyldCheckerImpl.h"
#include "Targets/RuntimeDyldELFMips.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Triple.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/Object/ELFObjectFile.h"
#include "llvm/Object/ObjectFile.h"
#include "llvm/Support/Endian.h"
#include "llvm/Support/MemoryBuffer.h"

using namespace llvm;
using namespace llvm::object;
using namespace llvm::support::endian;

#define DEBUG_TYPE "dyld"

static void or32le(void *P, int32_t V) { write32le(P, read32le(P) | V); }

static void or32AArch64Imm(void *L, uint64_t Imm) {
  or32le(L, (Imm & 0xFFF) << 10);
}

template <class T> static void write(bool isBE, void *P, T V) {
  isBE ? write<T, support::big>(P, V) : write<T, support::little>(P, V);
}

static void write32AArch64Addr(void *L, uint64_t Imm) {
  uint32_t ImmLo = (Imm & 0x3) << 29;
  uint32_t ImmHi = (Imm & 0x1FFFFC) << 3;
  uint64_t Mask = (0x3 << 29) | (0x1FFFFC << 3);
  write32le(L, (read32le(L) & ~Mask) | ImmLo | ImmHi);
}

// Return the bits [Start, End] from Val shifted Start bits.
// For instance, getBits(0xF0, 4, 8) returns 0xF.
static uint64_t getBits(uint64_t Val, int Start, int End) {
  uint64_t Mask = ((uint64_t)1 << (End + 1 - Start)) - 1;
  return (Val >> Start) & Mask;
}

namespace {

template <class ELFT> class DyldELFObject : public ELFObjectFile<ELFT> {
  LLVM_ELF_IMPORT_TYPES_ELFT(ELFT)

  typedef Elf_Shdr_Impl<ELFT> Elf_Shdr;
  typedef Elf_Sym_Impl<ELFT> Elf_Sym;
  typedef Elf_Rel_Impl<ELFT, false> Elf_Rel;
  typedef Elf_Rel_Impl<ELFT, true> Elf_Rela;

  typedef Elf_Ehdr_Impl<ELFT> Elf_Ehdr;

  typedef typename ELFT::uint addr_type;

  DyldELFObject(ELFObjectFile<ELFT> &&Obj);

public:
  static Expected<std::unique_ptr<DyldELFObject>>
  create(MemoryBufferRef Wrapper);

  void updateSectionAddress(const SectionRef &Sec, uint64_t Addr);

  void updateSymbolAddress(const SymbolRef &SymRef, uint64_t Addr);

  // Methods for type inquiry through isa, cast and dyn_cast
  static bool classof(const Binary *v) {
    return (isa<ELFObjectFile<ELFT>>(v) &&
            classof(cast<ELFObjectFile<ELFT>>(v)));
  }
  static bool classof(const ELFObjectFile<ELFT> *v) {
    return v->isDyldType();
  }
};



// The MemoryBuffer passed into this constructor is just a wrapper around the
// actual memory.  Ultimately, the Binary parent class will take ownership of
// this MemoryBuffer object but not the underlying memory.
template <class ELFT>
DyldELFObject<ELFT>::DyldELFObject(ELFObjectFile<ELFT> &&Obj)
    : ELFObjectFile<ELFT>(std::move(Obj)) {
  this->isDyldELFObject = true;
}

template <class ELFT>
Expected<std::unique_ptr<DyldELFObject<ELFT>>>
DyldELFObject<ELFT>::create(MemoryBufferRef Wrapper) {
  auto Obj = ELFObjectFile<ELFT>::create(Wrapper);
  if (auto E = Obj.takeError())
    return std::move(E);
  std::unique_ptr<DyldELFObject<ELFT>> Ret(
      new DyldELFObject<ELFT>(std::move(*Obj)));
  return std::move(Ret);
}

template <class ELFT>
void DyldELFObject<ELFT>::updateSectionAddress(const SectionRef &Sec,
                                               uint64_t Addr) {
  DataRefImpl ShdrRef = Sec.getRawDataRefImpl();
  Elf_Shdr *shdr =
      const_cast<Elf_Shdr *>(reinterpret_cast<const Elf_Shdr *>(ShdrRef.p));

  // This assumes the address passed in matches the target address bitness
  // The template-based type cast handles everything else.
  shdr->sh_addr = static_cast<addr_type>(Addr);
}

template <class ELFT>
void DyldELFObject<ELFT>::updateSymbolAddress(const SymbolRef &SymRef,
                                              uint64_t Addr) {

  Elf_Sym *sym = const_cast<Elf_Sym *>(
      ELFObjectFile<ELFT>::getSymbol(SymRef.getRawDataRefImpl()));

  // This assumes the address passed in matches the target address bitness
  // The template-based type cast handles everything else.
  sym->st_value = static_cast<addr_type>(Addr);
}

class LoadedELFObjectInfo final
    : public LoadedObjectInfoHelper<LoadedELFObjectInfo,
                                    RuntimeDyld::LoadedObjectInfo> {
public:
  LoadedELFObjectInfo(RuntimeDyldImpl &RTDyld, ObjSectionToIDMap ObjSecToIDMap)
      : LoadedObjectInfoHelper(RTDyld, std::move(ObjSecToIDMap)) {}

  OwningBinary<ObjectFile>
  getObjectForDebug(const ObjectFile &Obj) const override;
};

template <typename ELFT>
static Expected<std::unique_ptr<DyldELFObject<ELFT>>>
createRTDyldELFObject(MemoryBufferRef Buffer, const ObjectFile &SourceObject,
                      const LoadedELFObjectInfo &L) {
  typedef typename ELFT::Shdr Elf_Shdr;
  typedef typename ELFT::uint addr_type;

  Expected<std::unique_ptr<DyldELFObject<ELFT>>> ObjOrErr =
      DyldELFObject<ELFT>::create(Buffer);
  if (Error E = ObjOrErr.takeError())
    return std::move(E);

  std::unique_ptr<DyldELFObject<ELFT>> Obj = std::move(*ObjOrErr);

  // Iterate over all sections in the object.
  auto SI = SourceObject.section_begin();
  for (const auto &Sec : Obj->sections()) {
    Expected<StringRef> NameOrErr = Sec.getName();
    if (!NameOrErr) {
      consumeError(NameOrErr.takeError());
      continue;
    }

    if (*NameOrErr != "") {
      DataRefImpl ShdrRef = Sec.getRawDataRefImpl();
      Elf_Shdr *shdr = const_cast<Elf_Shdr *>(
          reinterpret_cast<const Elf_Shdr *>(ShdrRef.p));

      if (uint64_t SecLoadAddr = L.getSectionLoadAddress(*SI)) {
        // This assumes that the address passed in matches the target address
        // bitness. The template-based type cast handles everything else.
        shdr->sh_addr = static_cast<addr_type>(SecLoadAddr);
      }
    }
    ++SI;
  }

  return std::move(Obj);
}

static OwningBinary<ObjectFile>
createELFDebugObject(const ObjectFile &Obj, const LoadedELFObjectInfo &L) {
  assert(Obj.isELF() && "Not an ELF object file.");

  std::unique_ptr<MemoryBuffer> Buffer =
    MemoryBuffer::getMemBufferCopy(Obj.getData(), Obj.getFileName());

  Expected<std::unique_ptr<ObjectFile>> DebugObj(nullptr);
  handleAllErrors(DebugObj.takeError());
  if (Obj.getBytesInAddress() == 4 && Obj.isLittleEndian())
    DebugObj =
        createRTDyldELFObject<ELF32LE>(Buffer->getMemBufferRef(), Obj, L);
  else if (Obj.getBytesInAddress() == 4 && !Obj.isLittleEndian())
    DebugObj =
        createRTDyldELFObject<ELF32BE>(Buffer->getMemBufferRef(), Obj, L);
  else if (Obj.getBytesInAddress() == 8 && !Obj.isLittleEndian())
    DebugObj =
        createRTDyldELFObject<ELF64BE>(Buffer->getMemBufferRef(), Obj, L);
  else if (Obj.getBytesInAddress() == 8 && Obj.isLittleEndian())
    DebugObj =
        createRTDyldELFObject<ELF64LE>(Buffer->getMemBufferRef(), Obj, L);
  else
    llvm_unreachable("Unexpected ELF format");

  handleAllErrors(DebugObj.takeError());
  return OwningBinary<ObjectFile>(std::move(*DebugObj), std::move(Buffer));
}

OwningBinary<ObjectFile>
LoadedELFObjectInfo::getObjectForDebug(const ObjectFile &Obj) const {
  return createELFDebugObject(Obj, *this);
}

} // anonymous namespace

namespace llvm {

RuntimeDyldELF::RuntimeDyldELF(RuntimeDyld::MemoryManager &MemMgr,
                               JITSymbolResolver &Resolver)
    : RuntimeDyldImpl(MemMgr, Resolver), GOTSectionID(0), CurrentGOTIndex(0) {}
RuntimeDyldELF::~RuntimeDyldELF() {}

void RuntimeDyldELF::registerEHFrames() {
  for (int i = 0, e = UnregisteredEHFrameSections.size(); i != e; ++i) {
    SID EHFrameSID = UnregisteredEHFrameSections[i];
    uint8_t *EHFrameAddr = Sections[EHFrameSID].getAddress();
    uint64_t EHFrameLoadAddr = Sections[EHFrameSID].getLoadAddress();
    size_t EHFrameSize = Sections[EHFrameSID].getSize();
    MemMgr.registerEHFrames(EHFrameAddr, EHFrameLoadAddr, EHFrameSize);
  }
  UnregisteredEHFrameSections.clear();
}

std::unique_ptr<RuntimeDyldELF>
llvm::RuntimeDyldELF::create(Triple::ArchType Arch,
                             RuntimeDyld::MemoryManager &MemMgr,
                             JITSymbolResolver &Resolver) {
  switch (Arch) {
  default:
    return std::make_unique<RuntimeDyldELF>(MemMgr, Resolver);
  case Triple::mips:
  case Triple::mipsel:
  case Triple::mips64:
  case Triple::mips64el:
    return std::make_unique<RuntimeDyldELFMips>(MemMgr, Resolver);
  }
}

std::unique_ptr<RuntimeDyld::LoadedObjectInfo>
RuntimeDyldELF::loadObject(const object::ObjectFile &O) {
  if (auto ObjSectionToIDOrErr = loadObjectImpl(O))
    return std::make_unique<LoadedELFObjectInfo>(*this, *ObjSectionToIDOrErr);
  else {
    HasError = true;
    raw_string_ostream ErrStream(ErrorStr);
    logAllUnhandledErrors(ObjSectionToIDOrErr.takeError(), ErrStream);
    return nullptr;
  }
}

void RuntimeDyldELF::resolveX86_64Relocation(const SectionEntry &Section,
                                             uint64_t Offset, uint64_t Value,
                                             uint32_t Type, int64_t Addend,
                                             uint64_t SymOffset) {
  switch (Type) {
  default:
    llvm_unreachable("Relocation type not implemented yet!");
    break;
  case ELF::R_X86_64_NONE:
    break;
  case ELF::R_X86_64_64: {
    support::ulittle64_t::ref(Section.getAddressWithOffset(Offset)) =
        Value + Addend;
    LLVM_DEBUG(dbgs() << "Writing " << format("%p", (Value + Addend)) << " at "
                      << format("%p\n", Section.getAddressWithOffset(Offset)));
    break;
  }
  case ELF::R_X86_64_32:
  case ELF::R_X86_64_32S: {
    Value += Addend;
    assert((Type == ELF::R_X86_64_32 && (Value <= UINT32_MAX)) ||
           (Type == ELF::R_X86_64_32S &&
            ((int64_t)Value <= INT32_MAX && (int64_t)Value >= INT32_MIN)));
    uint32_t TruncatedAddr = (Value & 0xFFFFFFFF);
    support::ulittle32_t::ref(Section.getAddressWithOffset(Offset)) =
        TruncatedAddr;
    LLVM_DEBUG(dbgs() << "Writing " << format("%p", TruncatedAddr) << " at "
                      << format("%p\n", Section.getAddressWithOffset(Offset)));
    break;
  }
  case ELF::R_X86_64_PC8: {
    uint64_t FinalAddress = Section.getLoadAddressWithOffset(Offset);
    int64_t RealOffset = Value + Addend - FinalAddress;
    assert(isInt<8>(RealOffset));
    int8_t TruncOffset = (RealOffset & 0xFF);
    Section.getAddress()[Offset] = TruncOffset;
    break;
  }
  case ELF::R_X86_64_PC32: {
    uint64_t FinalAddress = Section.getLoadAddressWithOffset(Offset);
    int64_t RealOffset = Value + Addend - FinalAddress;
    assert(isInt<32>(RealOffset));
    int32_t TruncOffset = (RealOffset & 0xFFFFFFFF);
    support::ulittle32_t::ref(Section.getAddressWithOffset(Offset)) =
        TruncOffset;
    break;
  }
  case ELF::R_X86_64_PC64: {
    uint64_t FinalAddress = Section.getLoadAddressWithOffset(Offset);
    int64_t RealOffset = Value + Addend - FinalAddress;
    support::ulittle64_t::ref(Section.getAddressWithOffset(Offset)) =
        RealOffset;
    LLVM_DEBUG(dbgs() << "Writing " << format("%p", RealOffset) << " at "
                      << format("%p\n", FinalAddress));
    break;
  }
  case ELF::R_X86_64_GOTOFF64: {
    // Compute Value - GOTBase.
    uint64_t GOTBase = 0;
    for (const auto &Section : Sections) {
      if (Section.getName() == ".got") {
        GOTBase = Section.getLoadAddressWithOffset(0);
        break;
      }
    }
    assert(GOTBase != 0 && "missing GOT");
    int64_t GOTOffset = Value - GOTBase + Addend;
    support::ulittle64_t::ref(Section.getAddressWithOffset(Offset)) = GOTOffset;
    break;
  }
  }
}

void RuntimeDyldELF::resolveX86Relocation(const SectionEntry &Section,
                                          uint64_t Offset, uint32_t Value,
                                          uint32_t Type, int32_t Addend) {
  switch (Type) {
  case ELF::R_386_32: {
    support::ulittle32_t::ref(Section.getAddressWithOffset(Offset)) =
        Value + Addend;
    break;
  }
  // Handle R_386_PLT32 like R_386_PC32 since it should be able to
  // reach any 32 bit address.
  case ELF::R_386_PLT32:
  case ELF::R_386_PC32: {
    uint32_t FinalAddress =
        Section.getLoadAddressWithOffset(Offset) & 0xFFFFFFFF;
    uint32_t RealOffset = Value + Addend - FinalAddress;
    support::ulittle32_t::ref(Section.getAddressWithOffset(Offset)) =
        RealOffset;
    break;
  }
  default:
    // There are other relocation types, but it appears these are the
    // only ones currently used by the LLVM ELF object writer
    llvm_unreachable("Relocation type not implemented yet!");
    break;
  }
}

void RuntimeDyldELF::resolveAArch64Relocation(const SectionEntry &Section,
                                              uint64_t Offset, uint64_t Value,
                                              uint32_t Type, int64_t Addend) {
  uint32_t *TargetPtr =
      reinterpret_cast<uint32_t *>(Section.getAddressWithOffset(Offset));
  uint64_t FinalAddress = Section.getLoadAddressWithOffset(Offset);
  // Data should use target endian. Code should always use little endian.
  bool isBE = Arch == Triple::aarch64_be;

  LLVM_DEBUG(dbgs() << "resolveAArch64Relocation, LocalAddress: 0x"
                    << format("%llx", Section.getAddressWithOffset(Offset))
                    << " FinalAddress: 0x" << format("%llx", FinalAddress)
                    << " Value: 0x" << format("%llx", Value) << " Type: 0x"
                    << format("%x", Type) << " Addend: 0x"
                    << format("%llx", Addend) << "\n");

  switch (Type) {
  default:
    llvm_unreachable("Relocation type not implemented yet!");
    break;
  case ELF::R_AARCH64_ABS16: {
    uint64_t Result = Value + Addend;
    assert(static_cast<int64_t>(Result) >= INT16_MIN && Result < UINT16_MAX);
    write(isBE, TargetPtr, static_cast<uint16_t>(Result & 0xffffU));
    break;
  }
  case ELF::R_AARCH64_ABS32: {
    uint64_t Result = Value + Addend;
    assert(static_cast<int64_t>(Result) >= INT32_MIN && Result < UINT32_MAX);
    write(isBE, TargetPtr, static_cast<uint32_t>(Result & 0xffffffffU));
    break;
  }
  case ELF::R_AARCH64_ABS64:
    write(isBE, TargetPtr, Value + Addend);
    break;
  case ELF::R_AARCH64_PREL32: {
    uint64_t Result = Value + Addend - FinalAddress;
    assert(static_cast<int64_t>(Result) >= INT32_MIN &&
           static_cast<int64_t>(Result) <= UINT32_MAX);
    write(isBE, TargetPtr, static_cast<uint32_t>(Result & 0xffffffffU));
    break;
  }
  case ELF::R_AARCH64_PREL64:
    write(isBE, TargetPtr, Value + Addend - FinalAddress);
    break;
  case ELF::R_AARCH64_CALL26: // fallthrough
  case ELF::R_AARCH64_JUMP26: {
    // Operation: S+A-P. Set Call or B immediate value to bits fff_fffc of the
    // calculation.
    uint64_t BranchImm = Value + Addend - FinalAddress;

    // "Check that -2^27 <= result < 2^27".
    assert(isInt<28>(BranchImm));
    or32le(TargetPtr, (BranchImm & 0x0FFFFFFC) >> 2);
    break;
  }
  case ELF::R_AARCH64_MOVW_UABS_G3:
    or32le(TargetPtr, ((Value + Addend) & 0xFFFF000000000000) >> 43);
    break;
  case ELF::R_AARCH64_MOVW_UABS_G2_NC:
    or32le(TargetPtr, ((Value + Addend) & 0xFFFF00000000) >> 27);
    break;
  case ELF::R_AARCH64_MOVW_UABS_G1_NC:
    or32le(TargetPtr, ((Value + Addend) & 0xFFFF0000) >> 11);
    break;
  case ELF::R_AARCH64_MOVW_UABS_G0_NC:
    or32le(TargetPtr, ((Value + Addend) & 0xFFFF) << 5);
    break;
  case ELF::R_AARCH64_ADR_PREL_PG_HI21: {
    // Operation: Page(S+A) - Page(P)
    uint64_t Result =
        ((Value + Addend) & ~0xfffULL) - (FinalAddress & ~0xfffULL);

    // Check that -2^32 <= X < 2^32
    assert(isInt<33>(Result) && "overflow check failed for relocation");

    // Immediate goes in bits 30:29 + 5:23 of ADRP instruction, taken
    // from bits 32:12 of X.
    write32AArch64Addr(TargetPtr, Result >> 12);
    break;
  }
  case ELF::R_AARCH64_ADD_ABS_LO12_NC:
    // Operation: S + A
    // Immediate goes in bits 21:10 of LD/ST instruction, taken
    // from bits 11:0 of X
    or32AArch64Imm(TargetPtr, Value + Addend);
    break;
  case ELF::R_AARCH64_LDST8_ABS_LO12_NC:
    // Operation: S + A
    // Immediate goes in bits 21:10 of LD/ST instruction, taken
    // from bits 11:0 of X
    or32AArch64Imm(TargetPtr, getBits(Value + Addend, 0, 11));
    break;
  case ELF::R_AARCH64_LDST16_ABS_LO12_NC:
    // Operation: S + A
    // Immediate goes in bits 21:10 of LD/ST instruction, taken
    // from bits 11:1 of X
    or32AArch64Imm(TargetPtr, getBits(Value + Addend, 1, 11));
    break;
  case ELF::R_AARCH64_LDST32_ABS_LO12_NC:
    // Operation: S + A
    // Immediate goes in bits 21:10 of LD/ST instruction, taken
    // from bits 11:2 of X
    or32AArch64Imm(TargetPtr, getBits(Value + Addend, 2, 11));
    break;
  case ELF::R_AARCH64_LDST64_ABS_LO12_NC:
    // Operation: S + A
    // Immediate goes in bits 21:10 of LD/ST instruction, taken
    // from bits 11:3 of X
    or32AArch64Imm(TargetPtr, getBits(Value + Addend, 3, 11));
    break;
  case ELF::R_AARCH64_LDST128_ABS_LO12_NC:
    // Operation: S + A
    // Immediate goes in bits 21:10 of LD/ST instruction, taken
    // from bits 11:4 of X
    or32AArch64Imm(TargetPtr, getBits(Value + Addend, 4, 11));
    break;
  }
}

void RuntimeDyldELF::resolveARMRelocation(const SectionEntry &Section,
                                          uint64_t Offset, uint32_t Value,
                                          uint32_t Type, int32_t Addend) {
  // TODO: Add Thumb relocations.
  uint32_t *TargetPtr =
      reinterpret_cast<uint32_t *>(Section.getAddressWithOffset(Offset));
  uint32_t FinalAddress = Section.getLoadAddressWithOffset(Offset) & 0xFFFFFFFF;
  Value += Addend;

  LLVM_DEBUG(dbgs() << "resolveARMRelocation, LocalAddress: "
                    << Section.getAddressWithOffset(Offset)
                    << " FinalAddress: " << format("%p", FinalAddress)
                    << " Value: " << format("%x", Value)
                    << " Type: " << format("%x", Type)
                    << " Addend: " << format("%x", Addend) << "\n");

  switch (Type) {
  default:
    llvm_unreachable("Not implemented relocation type!");

  case ELF::R_ARM_NONE:
    break;
    // Write a 31bit signed offset
  case ELF::R_ARM_PREL31:
    support::ulittle32_t::ref{TargetPtr} =
        (support::ulittle32_t::ref{TargetPtr} & 0x80000000) |
        ((Value - FinalAddress) & ~0x80000000);
    break;
  case ELF::R_ARM_TARGET1:
  case ELF::R_ARM_ABS32:
    support::ulittle32_t::ref{TargetPtr} = Value;
    break;
    // Write first 16 bit of 32 bit value to the mov instruction.
    // Last 4 bit should be shifted.
  case ELF::R_ARM_MOVW_ABS_NC:
  case ELF::R_ARM_MOVT_ABS:
    if (Type == ELF::R_ARM_MOVW_ABS_NC)
      Value = Value & 0xFFFF;
    else if (Type == ELF::R_ARM_MOVT_ABS)
      Value = (Value >> 16) & 0xFFFF;
    support::ulittle32_t::ref{TargetPtr} =
        (support::ulittle32_t::ref{TargetPtr} & ~0x000F0FFF) | (Value & 0xFFF) |
        (((Value >> 12) & 0xF) << 16);
    break;
    // Write 24 bit relative value to the branch instruction.
  case ELF::R_ARM_PC24: // Fall through.
  case ELF::R_ARM_CALL: // Fall through.
  case ELF::R_ARM_JUMP24:
    int32_t RelValue = static_cast<int32_t>(Value - FinalAddress - 8);
    RelValue = (RelValue & 0x03FFFFFC) >> 2;
    assert((support::ulittle32_t::ref{TargetPtr} & 0xFFFFFF) == 0xFFFFFE);
    support::ulittle32_t::ref{TargetPtr} =
        (support::ulittle32_t::ref{TargetPtr} & 0xFF000000) | RelValue;
    break;
  }
}

void RuntimeDyldELF::setMipsABI(const ObjectFile &Obj) {
  if (Arch == Triple::UnknownArch ||
      !StringRef(Triple::getArchTypePrefix(Arch)).equals("mips")) {
    IsMipsO32ABI = false;
    IsMipsN32ABI = false;
    IsMipsN64ABI = false;
    return;
  }
  if (auto *E = dyn_cast<ELFObjectFileBase>(&Obj)) {
    unsigned AbiVariant = E->getPlatformFlags();
    IsMipsO32ABI = AbiVariant & ELF::EF_MIPS_ABI_O32;
    IsMipsN32ABI = AbiVariant & ELF::EF_MIPS_ABI2;
  }
  IsMipsN64ABI = Obj.getFileFormatName().equals("elf64-mips");
}

// Return the .TOC. section and offset.
Error RuntimeDyldELF::findPPC64TOCSection(const ELFObjectFileBase &Obj,
                                          ObjSectionToIDMap &LocalSections,
                                          RelocationValueRef &Rel) {
  // Set a default SectionID in case we do not find a TOC section below.
  // This may happen for references to TOC base base (sym@toc, .odp
  // relocation) without a .toc directive.  In this case just use the
  // first section (which is usually the .odp) since the code won't
  // reference the .toc base directly.
  Rel.SymbolName = nullptr;
  Rel.SectionID = 0;

  // The TOC consists of sections .got, .toc, .tocbss, .plt in that
  // order. The TOC starts where the first of these sections starts.
  for (auto &Section : Obj.sections()) {
    Expected<StringRef> NameOrErr = Section.getName();
    if (!NameOrErr)
      return NameOrErr.takeError();
    StringRef SectionName = *NameOrErr;

    if (SectionName == ".got"
        || SectionName == ".toc"
        || SectionName == ".tocbss"
        || SectionName == ".plt") {
      if (auto SectionIDOrErr =
            findOrEmitSection(Obj, Section, false, LocalSections))
        Rel.SectionID = *SectionIDOrErr;
      else
        return SectionIDOrErr.takeError();
      break;
    }
  }

  // Per the ppc64-elf-linux ABI, The TOC base is TOC value plus 0x8000
  // thus permitting a full 64 Kbytes segment.
  Rel.Addend = 0x8000;

  return Error::success();
}

// Returns the sections and offset associated with the ODP entry referenced
// by Symbol.
Error RuntimeDyldELF::findOPDEntrySection(const ELFObjectFileBase &Obj,
                                          ObjSectionToIDMap &LocalSections,
                                          RelocationValueRef &Rel) {
  // Get the ELF symbol value (st_value) to compare with Relocation offset in
  // .opd entries
  for (section_iterator si = Obj.section_begin(), se = Obj.section_end();
       si != se; ++si) {

    Expected<section_iterator> RelSecOrErr = si->getRelocatedSection();
    if (!RelSecOrErr)
      report_fatal_error(toString(RelSecOrErr.takeError()));

    section_iterator RelSecI = *RelSecOrErr;
    if (RelSecI == Obj.section_end())
      continue;

    Expected<StringRef> NameOrErr = RelSecI->getName();
    if (!NameOrErr)
      return NameOrErr.takeError();
    StringRef RelSectionName = *NameOrErr;

    if (RelSectionName != ".opd")
      continue;

    for (elf_relocation_iterator i = si->relocation_begin(),
                                 e = si->relocation_end();
         i != e;) {
      // The R_PPC64_ADDR64 relocation indicates the first field
      // of a .opd entry
      uint64_t TypeFunc = i->getType();
      if (TypeFunc != ELF::R_PPC64_ADDR64) {
        ++i;
        continue;
      }

      uint64_t TargetSymbolOffset = i->getOffset();
      symbol_iterator TargetSymbol = i->getSymbol();
      int64_t Addend;
      if (auto AddendOrErr = i->getAddend())
        Addend = *AddendOrErr;
      else
        return AddendOrErr.takeError();

      ++i;
      if (i == e)
        break;

      // Just check if following relocation is a R_PPC64_TOC
      uint64_t TypeTOC = i->getType();
      if (TypeTOC != ELF::R_PPC64_TOC)
        continue;

      // Finally compares the Symbol value and the target symbol offset
      // to check if this .opd entry refers to the symbol the relocation
      // points to.
      if (Rel.Addend != (int64_t)TargetSymbolOffset)
        continue;

      section_iterator TSI = Obj.section_end();
      if (auto TSIOrErr = TargetSymbol->getSection())
        TSI = *TSIOrErr;
      else
        return TSIOrErr.takeError();
      assert(TSI != Obj.section_end() && "TSI should refer to a valid section");

      bool IsCode = TSI->isText();
      if (auto SectionIDOrErr = findOrEmitSection(Obj, *TSI, IsCode,
                                                  LocalSections))
        Rel.SectionID = *SectionIDOrErr;
      else
        return SectionIDOrErr.takeError();
      Rel.Addend = (intptr_t)Addend;
      return Error::success();
    }
  }
  llvm_unreachable("Attempting to get address of ODP entry!");
}

// Relocation masks following the #lo(value), #hi(value), #ha(value),
// #higher(value), #highera(value), #highest(value), and #highesta(value)
// macros defined in section 4.5.1. Relocation Types of the PPC-elf64abi
// document.

static inline uint16_t applyPPClo(uint64_t value) { return value & 0xffff; }

static inline uint16_t applyPPChi(uint64_t value) {
  return (value >> 16) & 0xffff;
}

static inline uint16_t applyPPCha (uint64_t value) {
  return ((value + 0x8000) >> 16) & 0xffff;
}

static inline uint16_t applyPPChigher(uint64_t value) {
  return (value >> 32) & 0xffff;
}

static inline uint16_t applyPPChighera (uint64_t value) {
  return ((value + 0x8000) >> 32) & 0xffff;
}

static inline uint16_t applyPPChighest(uint64_t value) {
  return (value >> 48) & 0xffff;
}

static inline uint16_t applyPPChighesta (uint64_t value) {
  return ((value + 0x8000) >> 48) & 0xffff;
}

void RuntimeDyldELF::resolvePPC32Relocation(const SectionEntry &Section,
                                            uint64_t Offset, uint64_t Value,
                                            uint32_t Type, int64_t Addend) {
  uint8_t *LocalAddress = Section.getAddressWithOffset(Offset);
  switch (Type) {
  default:
    llvm_unreachable("Relocation type not implemented yet!");
    break;
  case ELF::R_PPC_ADDR16_LO:
    writeInt16BE(LocalAddress, applyPPClo(Value + Addend));
    break;
  case ELF::R_PPC_ADDR16_HI:
    writeInt16BE(LocalAddress, applyPPChi(Value + Addend));
    break;
  case ELF::R_PPC_ADDR16_HA:
    writeInt16BE(LocalAddress, applyPPCha(Value + Addend));
    break;
  }
}

void RuntimeDyldELF::resolvePPC64Relocation(const SectionEntry &Section,
                                            uint64_t Offset, uint64_t Value,
                                            uint32_t Type, int64_t Addend) {
  uint8_t *LocalAddress = Section.getAddressWithOffset(Offset);
  switch (Type) {
  default:
    llvm_unreachable("Relocation type not implemented yet!");
    break;
  case ELF::R_PPC64_ADDR16:
    writeInt16BE(LocalAddress, applyPPClo(Value + Addend));
    break;
  case ELF::R_PPC64_ADDR16_DS:
    writeInt16BE(LocalAddress, applyPPClo(Value + Addend) & ~3);
    break;
  case ELF::R_PPC64_ADDR16_LO:
    writeInt16BE(LocalAddress, applyPPClo(Value + Addend));
    break;
  case ELF::R_PPC64_ADDR16_LO_DS:
    writeInt16BE(LocalAddress, applyPPClo(Value + Addend) & ~3);
    break;
  case ELF::R_PPC64_ADDR16_HI:
  case ELF::R_PPC64_ADDR16_HIGH:
    writeInt16BE(LocalAddress, applyPPChi(Value + Addend));
    break;
  case ELF::R_PPC64_ADDR16_HA:
  case ELF::R_PPC64_ADDR16_HIGHA:
    writeInt16BE(LocalAddress, applyPPCha(Value + Addend));
    break;
  case ELF::R_PPC64_ADDR16_HIGHER:
    writeInt16BE(LocalAddress, applyPPChigher(Value + Addend));
    break;
  case ELF::R_PPC64_ADDR16_HIGHERA:
    writeInt16BE(LocalAddress, applyPPChighera(Value + Addend));
    break;
  case ELF::R_PPC64_ADDR16_HIGHEST:
    writeInt16BE(LocalAddress, applyPPChighest(Value + Addend));
    break;
  case ELF::R_PPC64_ADDR16_HIGHESTA:
    writeInt16BE(LocalAddress, applyPPChighesta(Value + Addend));
    break;
  case ELF::R_PPC64_ADDR14: {
    assert(((Value + Addend) & 3) == 0);
    // Preserve the AA/LK bits in the branch instruction
    uint8_t aalk = *(LocalAddress + 3);
    writeInt16BE(LocalAddress + 2, (aalk & 3) | ((Value + Addend) & 0xfffc));
  } break;
  case ELF::R_PPC64_REL16_LO: {
    uint64_t FinalAddress = Section.getLoadAddressWithOffset(Offset);
    uint64_t Delta = Value - FinalAddress + Addend;
    writeInt16BE(LocalAddress, applyPPClo(Delta));
  } break;
  case ELF::R_PPC64_REL16_HI: {
    uint64_t FinalAddress = Section.getLoadAddressWithOffset(Offset);
    uint64_t Delta = Value - FinalAddress + Addend;
    writeInt16BE(LocalAddress, applyPPChi(Delta));
  } break;
  case ELF::R_PPC64_REL16_HA: {
    uint64_t FinalAddress = Section.getLoadAddressWithOffset(Offset);
    uint64_t Delta = Value - FinalAddress + Addend;
    writeInt16BE(LocalAddress, applyPPCha(Delta));
  } break;
  case ELF::R_PPC64_ADDR32: {
    int64_t Result = static_cast<int64_t>(Value + Addend);
    if (SignExtend64<32>(Result) != Result)
      llvm_unreachable("Relocation R_PPC64_ADDR32 overflow");
    writeInt32BE(LocalAddress, Result);
  } break;
  case ELF::R_PPC64_REL24: {
    uint64_t FinalAddress = Section.getLoadAddressWithOffset(Offset);
    int64_t delta = static_cast<int64_t>(Value - FinalAddress + Addend);
    if (SignExtend64<26>(delta) != delta)
      llvm_unreachable("Relocation R_PPC64_REL24 overflow");
    // We preserve bits other than LI field, i.e. PO and AA/LK fields.
    uint32_t Inst = readBytesUnaligned(LocalAddress, 4);
    writeInt32BE(LocalAddress, (Inst & 0xFC000003) | (delta & 0x03FFFFFC));
  } break;
  case ELF::R_PPC64_REL32: {
    uint64_t FinalAddress = Section.getLoadAddressWithOffset(Offset);
    int64_t delta = static_cast<int64_t>(Value - FinalAddress + Addend);
    if (SignExtend64<32>(delta) != delta)
      llvm_unreachable("Relocation R_PPC64_REL32 overflow");
    writeInt32BE(LocalAddress, delta);
  } break;
  case ELF::R_PPC64_REL64: {
    uint64_t FinalAddress = Section.getLoadAddressWithOffset(Offset);
    uint64_t Delta = Value - FinalAddress + Addend;
    writeInt64BE(LocalAddress, Delta);
  } break;
  case ELF::R_PPC64_ADDR64:
    writeInt64BE(LocalAddress, Value + Addend);
    break;
  }
}

void RuntimeDyldELF::resolveSystemZRelocation(const SectionEntry &Section,
                                              uint64_t Offset, uint64_t Value,
                                              uint32_t Type, int64_t Addend) {
  uint8_t *LocalAddress = Section.getAddressWithOffset(Offset);
  switch (Type) {
  default:
    llvm_unreachable("Relocation type not implemented yet!");
    break;
  case ELF::R_390_PC16DBL:
  case ELF::R_390_PLT16DBL: {
    int64_t Delta = (Value + Addend) - Section.getLoadAddressWithOffset(Offset);
    assert(int16_t(Delta / 2) * 2 == Delta && "R_390_PC16DBL overflow");
    writeInt16BE(LocalAddress, Delta / 2);
    break;
  }
  case ELF::R_390_PC32DBL:
  case ELF::R_390_PLT32DBL: {
    int64_t Delta = (Value + Addend) - Section.getLoadAddressWithOffset(Offset);
    assert(int32_t(Delta / 2) * 2 == Delta && "R_390_PC32DBL overflow");
    writeInt32BE(LocalAddress, Delta / 2);
    break;
  }
  case ELF::R_390_PC16: {
    int64_t Delta = (Value + Addend) - Section.getLoadAddressWithOffset(Offset);
    assert(int16_t(Delta) == Delta && "R_390_PC16 overflow");
    writeInt16BE(LocalAddress, Delta);
    break;
  }
  case ELF::R_390_PC32: {
    int64_t Delta = (Value + Addend) - Section.getLoadAddressWithOffset(Offset);
    assert(int32_t(Delta) == Delta && "R_390_PC32 overflow");
    writeInt32BE(LocalAddress, Delta);
    break;
  }
  case ELF::R_390_PC64: {
    int64_t Delta = (Value + Addend) - Section.getLoadAddressWithOffset(Offset);
    writeInt64BE(LocalAddress, Delta);
    break;
  }
  case ELF::R_390_8:
    *LocalAddress = (uint8_t)(Value + Addend);
    break;
  case ELF::R_390_16:
    writeInt16BE(LocalAddress, Value + Addend);
    break;
  case ELF::R_390_32:
    writeInt32BE(LocalAddress, Value + Addend);
    break;
  case ELF::R_390_64:
    writeInt64BE(LocalAddress, Value + Addend);
    break;
  }
}

void RuntimeDyldELF::resolveBPFRelocation(const SectionEntry &Section,
                                          uint64_t Offset, uint64_t Value,
                                          uint32_t Type, int64_t Addend) {
  bool isBE = Arch == Triple::bpfeb;

  switch (Type) {
  default:
    llvm_unreachable("Relocation type not implemented yet!");
    break;
  case ELF::R_BPF_NONE:
    break;
  case ELF::R_BPF_64_64: {
    write(isBE, Section.getAddressWithOffset(Offset), Value + Addend);
    LLVM_DEBUG(dbgs() << "Writing " << format("%p", (Value + Addend)) << " at "
                      << format("%p\n", Section.getAddressWithOffset(Offset)));
    break;
  }
  case ELF::R_BPF_64_32: {
    Value += Addend;
    assert(Value <= UINT32_MAX);
    write(isBE, Section.getAddressWithOffset(Offset), static_cast<uint32_t>(Value));
    LLVM_DEBUG(dbgs() << "Writing " << format("%p", Value) << " at "
                      << format("%p\n", Section.getAddressWithOffset(Offset)));
    break;
  }
  }
}

// The target location for the relocation is described by RE.SectionID and
// RE.Offset.  RE.SectionID can be used to find the SectionEntry.  Each
// SectionEntry has three members describing its location.
// SectionEntry::Address is the address at which the section has been loaded
// into memory in the current (host) process.  SectionEntry::LoadAddress is the
// address that the section will have in the target process.
// SectionEntry::ObjAddress is the address of the bits for this section in the
// original emitted object image (also in the current address space).
//
// Relocations will be applied as if the section were loaded at
// SectionEntry::LoadAddress, but they will be applied at an address based
// on SectionEntry::Address.  SectionEntry::ObjAddress will be used to refer to
// Target memory contents if they are required for value calculations.
//
// The Value parameter here is the load address of the symbol for the
// relocation to be applied.  For relocations which refer to symbols in the
// current object Value will be the LoadAddress of the section in which
// the symbol resides (RE.Addend provides additional information about the
// symbol location).  For external symbols, Value will be the address of the
// symbol in the target address space.
void RuntimeDyldELF::resolveRelocation(const RelocationEntry &RE,
                                       uint64_t Value) {
  const SectionEntry &Section = Sections[RE.SectionID];
  return resolveRelocation(Section, RE.Offset, Value, RE.RelType, RE.Addend,
                           RE.SymOffset, RE.SectionID);
}

void RuntimeDyldELF::resolveRelocation(const SectionEntry &Section,
                                       uint64_t Offset, uint64_t Value,
                                       uint32_t Type, int64_t Addend,
                                       uint64_t SymOffset, SID SectionID) {
  switch (Arch) {
  case Triple::x86_64:
    resolveX86_64Relocation(Section, Offset, Value, Type, Addend, SymOffset);
    break;
  case Triple::x86:
    resolveX86Relocation(Section, Offset, (uint32_t)(Value & 0xffffffffL), Type,
                         (uint32_t)(Addend & 0xffffffffL));
    break;
  case Triple::aarch64:
  case Triple::aarch64_be:
    resolveAArch64Relocation(Section, Offset, Value, Type, Addend);
    break;
  case Triple::arm: // Fall through.
  case Triple::armeb:
  case Triple::thumb:
  case Triple::thumbeb:
    resolveARMRelocation(Section, Offset, (uint32_t)(Value & 0xffffffffL), Type,
                         (uint32_t)(Addend & 0xffffffffL));
    break;
  case Triple::ppc:
    resolvePPC32Relocation(Section, Offset, Value, Type, Addend);
    break;
  case Triple::ppc64: // Fall through.
  case Triple::ppc64le:
    resolvePPC64Relocation(Section, Offset, Value, Type, Addend);
    break;
  case Triple::systemz:
    resolveSystemZRelocation(Section, Offset, Value, Type, Addend);
    break;
  case Triple::bpfel:
  case Triple::bpfeb:
    resolveBPFRelocation(Section, Offset, Value, Type, Addend);
    break;
  default:
    llvm_unreachable("Unsupported CPU type!");
  }
}

void *RuntimeDyldELF::computePlaceholderAddress(unsigned SectionID, uint64_t Offset) const {
  return (void *)(Sections[SectionID].getObjAddress() + Offset);
}

void RuntimeDyldELF::processSimpleRelocation(unsigned SectionID, uint64_t Offset, unsigned RelType, RelocationValueRef Value) {
  RelocationEntry RE(SectionID, Offset, RelType, Value.Addend, Value.Offset);
  if (Value.SymbolName)
    addRelocationForSymbol(RE, Value.SymbolName);
  else
    addRelocationForSection(RE, Value.SectionID);
}

uint32_t RuntimeDyldELF::getMatchingLoRelocation(uint32_t RelType,
                                                 bool IsLocal) const {
  switch (RelType) {
  case ELF::R_MICROMIPS_GOT16:
    if (IsLocal)
      return ELF::R_MICROMIPS_LO16;
    break;
  case ELF::R_MICROMIPS_HI16:
    return ELF::R_MICROMIPS_LO16;
  case ELF::R_MIPS_GOT16:
    if (IsLocal)
      return ELF::R_MIPS_LO16;
    break;
  case ELF::R_MIPS_HI16:
    return ELF::R_MIPS_LO16;
  case ELF::R_MIPS_PCHI16:
    return ELF::R_MIPS_PCLO16;
  default:
    break;
  }
  return ELF::R_MIPS_NONE;
}

// Sometimes we don't need to create thunk for a branch.
// This typically happens when branch target is located
// in the same object file. In such case target is either
// a weak symbol or symbol in a different executable section.
// This function checks if branch target is located in the
// same object file and if distance between source and target
// fits R_AARCH64_CALL26 relocation. If both conditions are
// met, it emits direct jump to the target and returns true.
// Otherwise false is returned and thunk is created.
bool RuntimeDyldELF::resolveAArch64ShortBranch(
    unsigned SectionID, relocation_iterator RelI,
    const RelocationValueRef &Value) {
  uint64_t Address;
  if (Value.SymbolName) {
    auto Loc = GlobalSymbolTable.find(Value.SymbolName);

    // Don't create direct branch for external symbols.
    if (Loc == GlobalSymbolTable.end())
      return false;

    const auto &SymInfo = Loc->second;
    Address =
        uint64_t(Sections[SymInfo.getSectionID()].getLoadAddressWithOffset(
            SymInfo.getOffset()));
  } else {
    Address = uint64_t(Sections[Value.SectionID].getLoadAddress());
  }
  uint64_t Offset = RelI->getOffset();
  uint64_t SourceAddress = Sections[SectionID].getLoadAddressWithOffset(Offset);

  // R_AARCH64_CALL26 requires immediate to be in range -2^27 <= imm < 2^27
  // If distance between source and target is out of range then we should
  // create thunk.
  if (!isInt<28>(Address + Value.Addend - SourceAddress))
    return false;

  resolveRelocation(Sections[SectionID], Offset, Address, RelI->getType(),
                    Value.Addend);

  return true;
}

void RuntimeDyldELF::resolveAArch64Branch(unsigned SectionID,
                                          const RelocationValueRef &Value,
                                          relocation_iterator RelI,
                                          StubMap &Stubs) {

  LLVM_DEBUG(dbgs() << "\t\tThis is an AArch64 branch relocation.");
  SectionEntry &Section = Sections[SectionID];

  uint64_t Offset = RelI->getOffset();
  unsigned RelType = RelI->getType();
  // Look for an existing stub.
  StubMap::const_iterator i = Stubs.find(Value);
  if (i != Stubs.end()) {
    resolveRelocation(Section, Offset,
                      (uint64_t)Section.getAddressWithOffset(i->second),
                      RelType, 0);
    LLVM_DEBUG(dbgs() << " Stub function found\n");
  } else if (!resolveAArch64ShortBranch(SectionID, RelI, Value)) {
    // Create a new stub function.
    LLVM_DEBUG(dbgs() << " Create a new stub function\n");
    Stubs[Value] = Section.getStubOffset();
    uint8_t *StubTargetAddr = createStubFunction(
        Section.getAddressWithOffset(Section.getStubOffset()));

    RelocationEntry REmovz_g3(SectionID, StubTargetAddr - Section.getAddress(),
                              ELF::R_AARCH64_MOVW_UABS_G3, Value.Addend);
    RelocationEntry REmovk_g2(SectionID,
                              StubTargetAddr - Section.getAddress() + 4,
                              ELF::R_AARCH64_MOVW_UABS_G2_NC, Value.Addend);
    RelocationEntry REmovk_g1(SectionID,
                              StubTargetAddr - Section.getAddress() + 8,
                              ELF::R_AARCH64_MOVW_UABS_G1_NC, Value.Addend);
    RelocationEntry REmovk_g0(SectionID,
                              StubTargetAddr - Section.getAddress() + 12,
                              ELF::R_AARCH64_MOVW_UABS_G0_NC, Value.Addend);

    if (Value.SymbolName) {
      addRelocationForSymbol(REmovz_g3, Value.SymbolName);
      addRelocationForSymbol(REmovk_g2, Value.SymbolName);
      addRelocationForSymbol(REmovk_g1, Value.SymbolName);
      addRelocationForSymbol(REmovk_g0, Value.SymbolName);
    } else {
      addRelocationForSection(REmovz_g3, Value.SectionID);
      addRelocationForSection(REmovk_g2, Value.SectionID);
      addRelocationForSection(REmovk_g1, Value.SectionID);
      addRelocationForSection(REmovk_g0, Value.SectionID);
    }
    resolveRelocation(Section, Offset,
                      reinterpret_cast<uint64_t>(Section.getAddressWithOffset(
                          Section.getStubOffset())),
                      RelType, 0);
    Section.advanceStubOffset(getMaxStubSize());
  }
}

Expected<relocation_iterator>
RuntimeDyldELF::processRelocationRef(
    unsigned SectionID, relocation_iterator RelI, const ObjectFile &O,
    ObjSectionToIDMap &ObjSectionToID, StubMap &Stubs) {
  const auto &Obj = cast<ELFObjectFileBase>(O);
  uint64_t RelType = RelI->getType();
  int64_t Addend = 0;
  if (Expected<int64_t> AddendOrErr = ELFRelocationRef(*RelI).getAddend())
    Addend = *AddendOrErr;
  else
    consumeError(AddendOrErr.takeError());
  elf_symbol_iterator Symbol = RelI->getSymbol();

  // Obtain the symbol name which is referenced in the relocation
  StringRef TargetName;
  if (Symbol != Obj.symbol_end()) {
    if (auto TargetNameOrErr = Symbol->getName())
      TargetName = *TargetNameOrErr;
    else
      return TargetNameOrErr.takeError();
  }
  LLVM_DEBUG(dbgs() << "\t\tRelType: " << RelType << " Addend: " << Addend
                    << " TargetName: " << TargetName << "\n");
  RelocationValueRef Value;
  // First search for the symbol in the local symbol table
  SymbolRef::Type SymType = SymbolRef::ST_Unknown;

  // Search for the symbol in the global symbol table
  RTDyldSymbolTable::const_iterator gsi = GlobalSymbolTable.end();
  if (Symbol != Obj.symbol_end()) {
    gsi = GlobalSymbolTable.find(TargetName.data());
    Expected<SymbolRef::Type> SymTypeOrErr = Symbol->getType();
    if (!SymTypeOrErr) {
      std::string Buf;
      raw_string_ostream OS(Buf);
      logAllUnhandledErrors(SymTypeOrErr.takeError(), OS);
      OS.flush();
      report_fatal_error(Buf);
    }
    SymType = *SymTypeOrErr;
  }
  if (gsi != GlobalSymbolTable.end()) {
    const auto &SymInfo = gsi->second;
    Value.SectionID = SymInfo.getSectionID();
    Value.Offset = SymInfo.getOffset();
    Value.Addend = SymInfo.getOffset() + Addend;
  } else {
    switch (SymType) {
    case SymbolRef::ST_Debug: {
      // TODO: Now ELF SymbolRef::ST_Debug = STT_SECTION, it's not obviously
      // and can be changed by another developers. Maybe best way is add
      // a new symbol type ST_Section to SymbolRef and use it.
      auto SectionOrErr = Symbol->getSection();
      if (!SectionOrErr) {
        std::string Buf;
        raw_string_ostream OS(Buf);
        logAllUnhandledErrors(SectionOrErr.takeError(), OS);
        OS.flush();
        report_fatal_error(Buf);
      }
      section_iterator si = *SectionOrErr;
      if (si == Obj.section_end())
        llvm_unreachable("Symbol section not found, bad object file format!");
      LLVM_DEBUG(dbgs() << "\t\tThis is section symbol\n");
      bool isCode = si->isText();
      if (auto SectionIDOrErr = findOrEmitSection(Obj, (*si), isCode,
                                                  ObjSectionToID))
        Value.SectionID = *SectionIDOrErr;
      else
        return SectionIDOrErr.takeError();
      Value.Addend = Addend;
      break;
    }
    case SymbolRef::ST_Data:
    case SymbolRef::ST_Function:
    case SymbolRef::ST_Unknown: {
      Value.SymbolName = TargetName.data();
      Value.Addend = Addend;

      // Absolute relocations will have a zero symbol ID (STN_UNDEF), which
      // will manifest here as a NULL symbol name.
      // We can set this as a valid (but empty) symbol name, and rely
      // on addRelocationForSymbol to handle this.
      if (!Value.SymbolName)
        Value.SymbolName = "";
      break;
    }
    default:
      llvm_unreachable("Unresolved symbol type!");
      break;
    }
  }

  uint64_t Offset = RelI->getOffset();

  LLVM_DEBUG(dbgs() << "\t\tSectionID: " << SectionID << " Offset: " << Offset
                    << "\n");
  if ((Arch == Triple::aarch64 || Arch == Triple::aarch64_be)) {
    if (RelType == ELF::R_AARCH64_CALL26 || RelType == ELF::R_AARCH64_JUMP26) {
      resolveAArch64Branch(SectionID, Value, RelI, Stubs);
    } else if (RelType == ELF::R_AARCH64_ADR_GOT_PAGE) {
      // Craete new GOT entry or find existing one. If GOT entry is
      // to be created, then we also emit ABS64 relocation for it.
      uint64_t GOTOffset = findOrAllocGOTEntry(Value, ELF::R_AARCH64_ABS64);
      resolveGOTOffsetRelocation(SectionID, Offset, GOTOffset + Addend,
                                 ELF::R_AARCH64_ADR_PREL_PG_HI21);

    } else if (RelType == ELF::R_AARCH64_LD64_GOT_LO12_NC) {
      uint64_t GOTOffset = findOrAllocGOTEntry(Value, ELF::R_AARCH64_ABS64);
      resolveGOTOffsetRelocation(SectionID, Offset, GOTOffset + Addend,
                                 ELF::R_AARCH64_LDST64_ABS_LO12_NC);
    } else {
      processSimpleRelocation(SectionID, Offset, RelType, Value);
    }
  } else if (Arch == Triple::arm) {
    if (RelType == ELF::R_ARM_PC24 || RelType == ELF::R_ARM_CALL ||
      RelType == ELF::R_ARM_JUMP24) {
      // This is an ARM branch relocation, need to use a stub function.
      LLVM_DEBUG(dbgs() << "\t\tThis is an ARM branch relocation.\n");
      SectionEntry &Section = Sections[SectionID];

      // Look for an existing stub.
      StubMap::const_iterator i = Stubs.find(Value);
      if (i != Stubs.end()) {
        resolveRelocation(
            Section, Offset,
            reinterpret_cast<uint64_t>(Section.getAddressWithOffset(i->second)),
            RelType, 0);
        LLVM_DEBUG(dbgs() << " Stub function found\n");
      } else {
        // Create a new stub function.
        LLVM_DEBUG(dbgs() << " Create a new stub function\n");
        Stubs[Value] = Section.getStubOffset();
        uint8_t *StubTargetAddr = createStubFunction(
            Section.getAddressWithOffset(Section.getStubOffset()));
        RelocationEntry RE(SectionID, StubTargetAddr - Section.getAddress(),
                           ELF::R_ARM_ABS32, Value.Addend);
        if (Value.SymbolName)
          addRelocationForSymbol(RE, Value.SymbolName);
        else
          addRelocationForSection(RE, Value.SectionID);

        resolveRelocation(Section, Offset, reinterpret_cast<uint64_t>(
                                               Section.getAddressWithOffset(
                                                   Section.getStubOffset())),
                          RelType, 0);
        Section.advanceStubOffset(getMaxStubSize());
      }
    } else {
      uint32_t *Placeholder =
        reinterpret_cast<uint32_t*>(computePlaceholderAddress(SectionID, Offset));
      if (RelType == ELF::R_ARM_PREL31 || RelType == ELF::R_ARM_TARGET1 ||
          RelType == ELF::R_ARM_ABS32) {
        Value.Addend += *Placeholder;
      } else if (RelType == ELF::R_ARM_MOVW_ABS_NC || RelType == ELF::R_ARM_MOVT_ABS) {
        // See ELF for ARM documentation
        Value.Addend += (int16_t)((*Placeholder & 0xFFF) | (((*Placeholder >> 16) & 0xF) << 12));
      }
      processSimpleRelocation(SectionID, Offset, RelType, Value);
    }
  } else if (IsMipsO32ABI) {
    uint8_t *Placeholder = reinterpret_cast<uint8_t *>(
        computePlaceholderAddress(SectionID, Offset));
    uint32_t Opcode = readBytesUnaligned(Placeholder, 4);
    if (RelType == ELF::R_MIPS_26) {
      // This is an Mips branch relocation, need to use a stub function.
      LLVM_DEBUG(dbgs() << "\t\tThis is a Mips branch relocation.");
      SectionEntry &Section = Sections[SectionID];

      // Extract the addend from the instruction.
      // We shift up by two since the Value will be down shifted again
      // when applying the relocation.
      uint32_t Addend = (Opcode & 0x03ffffff) << 2;

      Value.Addend += Addend;

      //  Look up for existing stub.
      StubMap::const_iterator i = Stubs.find(Value);
      if (i != Stubs.end()) {
        RelocationEntry RE(SectionID, Offset, RelType, i->second);
        addRelocationForSection(RE, SectionID);
        LLVM_DEBUG(dbgs() << " Stub function found\n");
      } else {
        // Create a new stub function.
        LLVM_DEBUG(dbgs() << " Create a new stub function\n");
        Stubs[Value] = Section.getStubOffset();

        unsigned AbiVariant = Obj.getPlatformFlags();

        uint8_t *StubTargetAddr = createStubFunction(
            Section.getAddressWithOffset(Section.getStubOffset()), AbiVariant);

        // Creating Hi and Lo relocations for the filled stub instructions.
        RelocationEntry REHi(SectionID, StubTargetAddr - Section.getAddress(),
                             ELF::R_MIPS_HI16, Value.Addend);
        RelocationEntry RELo(SectionID,
                             StubTargetAddr - Section.getAddress() + 4,
                             ELF::R_MIPS_LO16, Value.Addend);

        if (Value.SymbolName) {
          addRelocationForSymbol(REHi, Value.SymbolName);
          addRelocationForSymbol(RELo, Value.SymbolName);
        } else {
          addRelocationForSection(REHi, Value.SectionID);
          addRelocationForSection(RELo, Value.SectionID);
        }

        RelocationEntry RE(SectionID, Offset, RelType, Section.getStubOffset());
        addRelocationForSection(RE, SectionID);
        Section.advanceStubOffset(getMaxStubSize());
      }
    } else if (RelType == ELF::R_MIPS_HI16 || RelType == ELF::R_MIPS_PCHI16) {
      int64_t Addend = (Opcode & 0x0000ffff) << 16;
      RelocationEntry RE(SectionID, Offset, RelType, Addend);
      PendingRelocs.push_back(std::make_pair(Value, RE));
    } else if (RelType == ELF::R_MIPS_LO16 || RelType == ELF::R_MIPS_PCLO16) {
      int64_t Addend = Value.Addend + SignExtend32<16>(Opcode & 0x0000ffff);
      for (auto I = PendingRelocs.begin(); I != PendingRelocs.end();) {
        const RelocationValueRef &MatchingValue = I->first;
        RelocationEntry &Reloc = I->second;
        if (MatchingValue == Value &&
            RelType == getMatchingLoRelocation(Reloc.RelType) &&
            SectionID == Reloc.SectionID) {
          Reloc.Addend += Addend;
          if (Value.SymbolName)
            addRelocationForSymbol(Reloc, Value.SymbolName);
          else
            addRelocationForSection(Reloc, Value.SectionID);
          I = PendingRelocs.erase(I);
        } else
          ++I;
      }
      RelocationEntry RE(SectionID, Offset, RelType, Addend);
      if (Value.SymbolName)
        addRelocationForSymbol(RE, Value.SymbolName);
      else
        addRelocationForSection(RE, Value.SectionID);
    } else {
      if (RelType == ELF::R_MIPS_32)
        Value.Addend += Opcode;
      else if (RelType == ELF::R_MIPS_PC16)
        Value.Addend += SignExtend32<18>((Opcode & 0x0000ffff) << 2);
      else if (RelType == ELF::R_MIPS_PC19_S2)
        Value.Addend += SignExtend32<21>((Opcode & 0x0007ffff) << 2);
      else if (RelType == ELF::R_MIPS_PC21_S2)
        Value.Addend += SignExtend32<23>((Opcode & 0x001fffff) << 2);
      else if (RelType == ELF::R_MIPS_PC26_S2)
        Value.Addend += SignExtend32<28>((Opcode & 0x03ffffff) << 2);
      processSimpleRelocation(SectionID, Offset, RelType, Value);
    }
  } else if (IsMipsN32ABI || IsMipsN64ABI) {
    uint32_t r_type = RelType & 0xff;
    RelocationEntry RE(SectionID, Offset, RelType, Value.Addend);
    if (r_type == ELF::R_MIPS_CALL16 || r_type == ELF::R_MIPS_GOT_PAGE
        || r_type == ELF::R_MIPS_GOT_DISP) {
      StringMap<uint64_t>::iterator i = GOTSymbolOffsets.find(TargetName);
      if (i != GOTSymbolOffsets.end())
        RE.SymOffset = i->second;
      else {
        RE.SymOffset = allocateGOTEntries(1);
        GOTSymbolOffsets[TargetName] = RE.SymOffset;
      }
      if (Value.SymbolName)
        addRelocationForSymbol(RE, Value.SymbolName);
      else
        addRelocationForSection(RE, Value.SectionID);
    } else if (RelType == ELF::R_MIPS_26) {
      // This is an Mips branch relocation, need to use a stub function.
      LLVM_DEBUG(dbgs() << "\t\tThis is a Mips branch relocation.");
      SectionEntry &Section = Sections[SectionID];

      //  Look up for existing stub.
      StubMap::const_iterator i = Stubs.find(Value);
      if (i != Stubs.end()) {
        RelocationEntry RE(SectionID, Offset, RelType, i->second);
        addRelocationForSection(RE, SectionID);
        LLVM_DEBUG(dbgs() << " Stub function found\n");
      } else {
        // Create a new stub function.
        LLVM_DEBUG(dbgs() << " Create a new stub function\n");
        Stubs[Value] = Section.getStubOffset();

        unsigned AbiVariant = Obj.getPlatformFlags();

        uint8_t *StubTargetAddr = createStubFunction(
            Section.getAddressWithOffset(Section.getStubOffset()), AbiVariant);

        if (IsMipsN32ABI) {
          // Creating Hi and Lo relocations for the filled stub instructions.
          RelocationEntry REHi(SectionID, StubTargetAddr - Section.getAddress(),
                               ELF::R_MIPS_HI16, Value.Addend);
          RelocationEntry RELo(SectionID,
                               StubTargetAddr - Section.getAddress() + 4,
                               ELF::R_MIPS_LO16, Value.Addend);
          if (Value.SymbolName) {
            addRelocationForSymbol(REHi, Value.SymbolName);
            addRelocationForSymbol(RELo, Value.SymbolName);
          } else {
            addRelocationForSection(REHi, Value.SectionID);
            addRelocationForSection(RELo, Value.SectionID);
          }
        } else {
          // Creating Highest, Higher, Hi and Lo relocations for the filled stub
          // instructions.
          RelocationEntry REHighest(SectionID,
                                    StubTargetAddr - Section.getAddress(),
                                    ELF::R_MIPS_HIGHEST, Value.Addend);
          RelocationEntry REHigher(SectionID,
                                   StubTargetAddr - Section.getAddress() + 4,
                                   ELF::R_MIPS_HIGHER, Value.Addend);
          RelocationEntry REHi(SectionID,
                               StubTargetAddr - Section.getAddress() + 12,
                               ELF::R_MIPS_HI16, Value.Addend);
          RelocationEntry RELo(SectionID,
                               StubTargetAddr - Section.getAddress() + 20,
                               ELF::R_MIPS_LO16, Value.Addend);
          if (Value.SymbolName) {
            addRelocationForSymbol(REHighest, Value.SymbolName);
            addRelocationForSymbol(REHigher, Value.SymbolName);
            addRelocationForSymbol(REHi, Value.SymbolName);
            addRelocationForSymbol(RELo, Value.SymbolName);
          } else {
            addRelocationForSection(REHighest, Value.SectionID);
            addRelocationForSection(REHigher, Value.SectionID);
            addRelocationForSection(REHi, Value.SectionID);
            addRelocationForSection(RELo, Value.SectionID);
          }
        }
        RelocationEntry RE(SectionID, Offset, RelType, Section.getStubOffset());
        addRelocationForSection(RE, SectionID);
        Section.advanceStubOffset(getMaxStubSize());
      }
    } else {
      processSimpleRelocation(SectionID, Offset, RelType, Value);
    }

  } else if (Arch == Triple::ppc64 || Arch == Triple::ppc64le) {
    if (RelType == ELF::R_PPC64_REL24) {
      // Determine ABI variant in use for this object.
      unsigned AbiVariant = Obj.getPlatformFlags();
      AbiVariant &= ELF::EF_PPC64_ABI;
      // A PPC branch relocation will need a stub function if the target is
      // an external symbol (either Value.SymbolName is set, or SymType is
      // Symbol::ST_Unknown) or if the target address is not within the
      // signed 24-bits branch address.
      SectionEntry &Section = Sections[SectionID];
      uint8_t *Target = Section.getAddressWithOffset(Offset);
      bool RangeOverflow = false;
      bool IsExtern = Value.SymbolName || SymType == SymbolRef::ST_Unknown;
      if (!IsExtern) {
        if (AbiVariant != 2) {
          // In the ELFv1 ABI, a function call may point to the .opd entry,
          // so the final symbol value is calculated based on the relocation
          // values in the .opd section.
          if (auto Err = findOPDEntrySection(Obj, ObjSectionToID, Value))
            return std::move(Err);
        } else {
          // In the ELFv2 ABI, a function symbol may provide a local entry
          // point, which must be used for direct calls.
          if (Value.SectionID == SectionID){
            uint8_t SymOther = Symbol->getOther();
            Value.Addend += ELF::decodePPC64LocalEntryOffset(SymOther);
          }
        }
        uint8_t *RelocTarget =
            Sections[Value.SectionID].getAddressWithOffset(Value.Addend);
        int64_t delta = static_cast<int64_t>(Target - RelocTarget);
        // If it is within 26-bits branch range, just set the branch target
        if (SignExtend64<26>(delta) != delta) {
          RangeOverflow = true;
        } else if ((AbiVariant != 2) ||
                   (AbiVariant == 2  && Value.SectionID == SectionID)) {
          RelocationEntry RE(SectionID, Offset, RelType, Value.Addend);
          addRelocationForSection(RE, Value.SectionID);
        }
      }
      if (IsExtern || (AbiVariant == 2 && Value.SectionID != SectionID) ||
          RangeOverflow) {
        // It is an external symbol (either Value.SymbolName is set, or
        // SymType is SymbolRef::ST_Unknown) or out of range.
        StubMap::const_iterator i = Stubs.find(Value);
        if (i != Stubs.end()) {
          // Symbol function stub already created, just relocate to it
          resolveRelocation(Section, Offset,
                            reinterpret_cast<uint64_t>(
                                Section.getAddressWithOffset(i->second)),
                            RelType, 0);
          LLVM_DEBUG(dbgs() << " Stub function found\n");
        } else {
          // Create a new stub function.
          LLVM_DEBUG(dbgs() << " Create a new stub function\n");
          Stubs[Value] = Section.getStubOffset();
          uint8_t *StubTargetAddr = createStubFunction(
              Section.getAddressWithOffset(Section.getStubOffset()),
              AbiVariant);
          RelocationEntry RE(SectionID, StubTargetAddr - Section.getAddress(),
                             ELF::R_PPC64_ADDR64, Value.Addend);

          // Generates the 64-bits address loads as exemplified in section
          // 4.5.1 in PPC64 ELF ABI.  Note that the relocations need to
          // apply to the low part of the instructions, so we have to update
          // the offset according to the target endianness.
          uint64_t StubRelocOffset = StubTargetAddr - Section.getAddress();
          if (!IsTargetLittleEndian)
            StubRelocOffset += 2;

          RelocationEntry REhst(SectionID, StubRelocOffset + 0,
                                ELF::R_PPC64_ADDR16_HIGHEST, Value.Addend);
          RelocationEntry REhr(SectionID, StubRelocOffset + 4,
                               ELF::R_PPC64_ADDR16_HIGHER, Value.Addend);
          RelocationEntry REh(SectionID, StubRelocOffset + 12,
                              ELF::R_PPC64_ADDR16_HI, Value.Addend);
          RelocationEntry REl(SectionID, StubRelocOffset + 16,
                              ELF::R_PPC64_ADDR16_LO, Value.Addend);

          if (Value.SymbolName) {
            addRelocationForSymbol(REhst, Value.SymbolName);
            addRelocationForSymbol(REhr, Value.SymbolName);
            addRelocationForSymbol(REh, Value.SymbolName);
            addRelocationForSymbol(REl, Value.SymbolName);
          } else {
            addRelocationForSection(REhst, Value.SectionID);
            addRelocationForSection(REhr, Value.SectionID);
            addRelocationForSection(REh, Value.SectionID);
            addRelocationForSection(REl, Value.SectionID);
          }

          resolveRelocation(Section, Offset, reinterpret_cast<uint64_t>(
                                                 Section.getAddressWithOffset(
                                                     Section.getStubOffset())),
                            RelType, 0);
          Section.advanceStubOffset(getMaxStubSize());
        }
        if (IsExtern || (AbiVariant == 2 && Value.SectionID != SectionID)) {
          // Restore the TOC for external calls
          if (AbiVariant == 2)
            writeInt32BE(Target + 4, 0xE8410018); // ld r2,24(r1)
          else
            writeInt32BE(Target + 4, 0xE8410028); // ld r2,40(r1)
        }
      }
    } else if (RelType == ELF::R_PPC64_TOC16 ||
               RelType == ELF::R_PPC64_TOC16_DS ||
               RelType == ELF::R_PPC64_TOC16_LO ||
               RelType == ELF::R_PPC64_TOC16_LO_DS ||
               RelType == ELF::R_PPC64_TOC16_HI ||
               RelType == ELF::R_PPC64_TOC16_HA) {
      // These relocations are supposed to subtract the TOC address from
      // the final value.  This does not fit cleanly into the RuntimeDyld
      // scheme, since there may be *two* sections involved in determining
      // the relocation value (the section of the symbol referred to by the
      // relocation, and the TOC section associated with the current module).
      //
      // Fortunately, these relocations are currently only ever generated
      // referring to symbols that themselves reside in the TOC, which means
      // that the two sections are actually the same.  Thus they cancel out
      // and we can immediately resolve the relocation right now.
      switch (RelType) {
      case ELF::R_PPC64_TOC16: RelType = ELF::R_PPC64_ADDR16; break;
      case ELF::R_PPC64_TOC16_DS: RelType = ELF::R_PPC64_ADDR16_DS; break;
      case ELF::R_PPC64_TOC16_LO: RelType = ELF::R_PPC64_ADDR16_LO; break;
      case ELF::R_PPC64_TOC16_LO_DS: RelType = ELF::R_PPC64_ADDR16_LO_DS; break;
      case ELF::R_PPC64_TOC16_HI: RelType = ELF::R_PPC64_ADDR16_HI; break;
      case ELF::R_PPC64_TOC16_HA: RelType = ELF::R_PPC64_ADDR16_HA; break;
      default: llvm_unreachable("Wrong relocation type.");
      }

      RelocationValueRef TOCValue;
      if (auto Err = findPPC64TOCSection(Obj, ObjSectionToID, TOCValue))
        return std::move(Err);
      if (Value.SymbolName || Value.SectionID != TOCValue.SectionID)
        llvm_unreachable("Unsupported TOC relocation.");
      Value.Addend -= TOCValue.Addend;
      resolveRelocation(Sections[SectionID], Offset, Value.Addend, RelType, 0);
    } else {
      // There are two ways to refer to the TOC address directly: either
      // via a ELF::R_PPC64_TOC relocation (where both symbol and addend are
      // ignored), or via any relocation that refers to the magic ".TOC."
      // symbols (in which case the addend is respected).
      if (RelType == ELF::R_PPC64_TOC) {
        RelType = ELF::R_PPC64_ADDR64;
        if (auto Err = findPPC64TOCSection(Obj, ObjSectionToID, Value))
          return std::move(Err);
      } else if (TargetName == ".TOC.") {
        if (auto Err = findPPC64TOCSection(Obj, ObjSectionToID, Value))
          return std::move(Err);
        Value.Addend += Addend;
      }

      RelocationEntry RE(SectionID, Offset, RelType, Value.Addend);

      if (Value.SymbolName)
        addRelocationForSymbol(RE, Value.SymbolName);
      else
        addRelocationForSection(RE, Value.SectionID);
    }
  } else if (Arch == Triple::systemz &&
             (RelType == ELF::R_390_PLT32DBL || RelType == ELF::R_390_GOTENT)) {
    // Create function stubs for both PLT and GOT references, regardless of
    // whether the GOT reference is to data or code.  The stub contains the
    // full address of the symbol, as needed by GOT references, and the
    // executable part only adds an overhead of 8 bytes.
    //
    // We could try to conserve space by allocating the code and data
    // parts of the stub separately.  However, as things stand, we allocate
    // a stub for every relocation, so using a GOT in JIT code should be
    // no less space efficient than using an explicit constant pool.
    LLVM_DEBUG(dbgs() << "\t\tThis is a SystemZ indirect relocation.");
    SectionEntry &Section = Sections[SectionID];

    // Look for an existing stub.
    StubMap::const_iterator i = Stubs.find(Value);
    uintptr_t StubAddress;
    if (i != Stubs.end()) {
      StubAddress = uintptr_t(Section.getAddressWithOffset(i->second));
      LLVM_DEBUG(dbgs() << " Stub function found\n");
    } else {
      // Create a new stub function.
      LLVM_DEBUG(dbgs() << " Create a new stub function\n");

      uintptr_t BaseAddress = uintptr_t(Section.getAddress());
      uintptr_t StubAlignment = getStubAlignment();
      StubAddress =
          (BaseAddress + Section.getStubOffset() + StubAlignment - 1) &
          -StubAlignment;
      unsigned StubOffset = StubAddress - BaseAddress;

      Stubs[Value] = StubOffset;
      createStubFunction((uint8_t *)StubAddress);
      RelocationEntry RE(SectionID, StubOffset + 8, ELF::R_390_64,
                         Value.Offset);
      if (Value.SymbolName)
        addRelocationForSymbol(RE, Value.SymbolName);
      else
        addRelocationForSection(RE, Value.SectionID);
      Section.advanceStubOffset(getMaxStubSize());
    }

    if (RelType == ELF::R_390_GOTENT)
      resolveRelocation(Section, Offset, StubAddress + 8, ELF::R_390_PC32DBL,
                        Addend);
    else
      resolveRelocation(Section, Offset, StubAddress, RelType, Addend);
  } else if (Arch == Triple::x86_64) {
    if (RelType == ELF::R_X86_64_PLT32) {
      // The way the PLT relocations normally work is that the linker allocates
      // the
      // PLT and this relocation makes a PC-relative call into the PLT.  The PLT
      // entry will then jump to an address provided by the GOT.  On first call,
      // the
      // GOT address will point back into PLT code that resolves the symbol. After
      // the first call, the GOT entry points to the actual function.
      //
      // For local functions we're ignoring all of that here and just replacing
      // the PLT32 relocation type with PC32, which will translate the relocation
      // into a PC-relative call directly to the function. For external symbols we
      // can't be sure the function will be within 2^32 bytes of the call site, so
      // we need to create a stub, which calls into the GOT.  This case is
      // equivalent to the usual PLT implementation except that we use the stub
      // mechanism in RuntimeDyld (which puts stubs at the end of the section)
      // rather than allocating a PLT section.
      if (Value.SymbolName) {
        // This is a call to an external function.
        // Look for an existing stub.
        SectionEntry &Section = Sections[SectionID];
        StubMap::const_iterator i = Stubs.find(Value);
        uintptr_t StubAddress;
        if (i != Stubs.end()) {
          StubAddress = uintptr_t(Section.getAddress()) + i->second;
          LLVM_DEBUG(dbgs() << " Stub function found\n");
        } else {
          // Create a new stub function (equivalent to a PLT entry).
          LLVM_DEBUG(dbgs() << " Create a new stub function\n");

          uintptr_t BaseAddress = uintptr_t(Section.getAddress());
          uintptr_t StubAlignment = getStubAlignment();
          StubAddress =
              (BaseAddress + Section.getStubOffset() + StubAlignment - 1) &
              -StubAlignment;
          unsigned StubOffset = StubAddress - BaseAddress;
          Stubs[Value] = StubOffset;
          createStubFunction((uint8_t *)StubAddress);

          // Bump our stub offset counter
          Section.advanceStubOffset(getMaxStubSize());

          // Allocate a GOT Entry
          uint64_t GOTOffset = allocateGOTEntries(1);

          // The load of the GOT address has an addend of -4
          resolveGOTOffsetRelocation(SectionID, StubOffset + 2, GOTOffset - 4,
                                     ELF::R_X86_64_PC32);

          // Fill in the value of the symbol we're targeting into the GOT
          addRelocationForSymbol(
              computeGOTOffsetRE(GOTOffset, 0, ELF::R_X86_64_64),
              Value.SymbolName);
        }

        // Make the target call a call into the stub table.
        resolveRelocation(Section, Offset, StubAddress, ELF::R_X86_64_PC32,
                          Addend);
      } else {
        RelocationEntry RE(SectionID, Offset, ELF::R_X86_64_PC32, Value.Addend,
                  Value.Offset);
        addRelocationForSection(RE, Value.SectionID);
      }
    } else if (RelType == ELF::R_X86_64_GOTPCREL ||
               RelType == ELF::R_X86_64_GOTPCRELX ||
               RelType == ELF::R_X86_64_REX_GOTPCRELX) {
      uint64_t GOTOffset = allocateGOTEntries(1);
      resolveGOTOffsetRelocation(SectionID, Offset, GOTOffset + Addend,
                                 ELF::R_X86_64_PC32);

      // Fill in the value of the symbol we're targeting into the GOT
      RelocationEntry RE =
          computeGOTOffsetRE(GOTOffset, Value.Offset, ELF::R_X86_64_64);
      if (Value.SymbolName)
        addRelocationForSymbol(RE, Value.SymbolName);
      else
        addRelocationForSection(RE, Value.SectionID);
    } else if (RelType == ELF::R_X86_64_GOT64) {
      // Fill in a 64-bit GOT offset.
      uint64_t GOTOffset = allocateGOTEntries(1);
      resolveRelocation(Sections[SectionID], Offset, GOTOffset,
                        ELF::R_X86_64_64, 0);

      // Fill in the value of the symbol we're targeting into the GOT
      RelocationEntry RE =
          computeGOTOffsetRE(GOTOffset, Value.Offset, ELF::R_X86_64_64);
      if (Value.SymbolName)
        addRelocationForSymbol(RE, Value.SymbolName);
      else
        addRelocationForSection(RE, Value.SectionID);
    } else if (RelType == ELF::R_X86_64_GOTPC64) {
      // Materialize the address of the base of the GOT relative to the PC.
      // This doesn't create a GOT entry, but it does mean we need a GOT
      // section.
      (void)allocateGOTEntries(0);
      resolveGOTOffsetRelocation(SectionID, Offset, Addend, ELF::R_X86_64_PC64);
    } else if (RelType == ELF::R_X86_64_GOTOFF64) {
      // GOTOFF relocations ultimately require a section difference relocation.
      (void)allocateGOTEntries(0);
      processSimpleRelocation(SectionID, Offset, RelType, Value);
    } else if (RelType == ELF::R_X86_64_PC32) {
      Value.Addend += support::ulittle32_t::ref(computePlaceholderAddress(SectionID, Offset));
      processSimpleRelocation(SectionID, Offset, RelType, Value);
    } else if (RelType == ELF::R_X86_64_PC64) {
      Value.Addend += support::ulittle64_t::ref(computePlaceholderAddress(SectionID, Offset));
      processSimpleRelocation(SectionID, Offset, RelType, Value);
    } else {
      processSimpleRelocation(SectionID, Offset, RelType, Value);
    }
  } else {
    if (Arch == Triple::x86) {
      Value.Addend += support::ulittle32_t::ref(computePlaceholderAddress(SectionID, Offset));
    }
    processSimpleRelocation(SectionID, Offset, RelType, Value);
  }
  return ++RelI;
}

size_t RuntimeDyldELF::getGOTEntrySize() {
  // We don't use the GOT in all of these cases, but it's essentially free
  // to put them all here.
  size_t Result = 0;
  switch (Arch) {
  case Triple::x86_64:
  case Triple::aarch64:
  case Triple::aarch64_be:
  case Triple::ppc64:
  case Triple::ppc64le:
  case Triple::systemz:
    Result = sizeof(uint64_t);
    break;
  case Triple::x86:
  case Triple::arm:
  case Triple::thumb:
    Result = sizeof(uint32_t);
    break;
  case Triple::mips:
  case Triple::mipsel:
  case Triple::mips64:
  case Triple::mips64el:
    if (IsMipsO32ABI || IsMipsN32ABI)
      Result = sizeof(uint32_t);
    else if (IsMipsN64ABI)
      Result = sizeof(uint64_t);
    else
      llvm_unreachable("Mips ABI not handled");
    break;
  default:
    llvm_unreachable("Unsupported CPU type!");
  }
  return Result;
}

uint64_t RuntimeDyldELF::allocateGOTEntries(unsigned no) {
  if (GOTSectionID == 0) {
    GOTSectionID = Sections.size();
    // Reserve a section id. We'll allocate the section later
    // once we know the total size
    Sections.push_back(SectionEntry(".got", nullptr, 0, 0, 0));
  }
  uint64_t StartOffset = CurrentGOTIndex * getGOTEntrySize();
  CurrentGOTIndex += no;
  return StartOffset;
}

uint64_t RuntimeDyldELF::findOrAllocGOTEntry(const RelocationValueRef &Value,
                                             unsigned GOTRelType) {
  auto E = GOTOffsetMap.insert({Value, 0});
  if (E.second) {
    uint64_t GOTOffset = allocateGOTEntries(1);

    // Create relocation for newly created GOT entry
    RelocationEntry RE =
        computeGOTOffsetRE(GOTOffset, Value.Offset, GOTRelType);
    if (Value.SymbolName)
      addRelocationForSymbol(RE, Value.SymbolName);
    else
      addRelocationForSection(RE, Value.SectionID);

    E.first->second = GOTOffset;
  }

  return E.first->second;
}

void RuntimeDyldELF::resolveGOTOffsetRelocation(unsigned SectionID,
                                                uint64_t Offset,
                                                uint64_t GOTOffset,
                                                uint32_t Type) {
  // Fill in the relative address of the GOT Entry into the stub
  RelocationEntry GOTRE(SectionID, Offset, Type, GOTOffset);
  addRelocationForSection(GOTRE, GOTSectionID);
}

RelocationEntry RuntimeDyldELF::computeGOTOffsetRE(uint64_t GOTOffset,
                                                   uint64_t SymbolOffset,
                                                   uint32_t Type) {
  return RelocationEntry(GOTSectionID, GOTOffset, Type, SymbolOffset);
}

Error RuntimeDyldELF::finalizeLoad(const ObjectFile &Obj,
                                  ObjSectionToIDMap &SectionMap) {
  if (IsMipsO32ABI)
    if (!PendingRelocs.empty())
      return make_error<RuntimeDyldError>("Can't find matching LO16 reloc");

  // If necessary, allocate the global offset table
  if (GOTSectionID != 0) {
    // Allocate memory for the section
    size_t TotalSize = CurrentGOTIndex * getGOTEntrySize();
    uint8_t *Addr = MemMgr.allocateDataSection(TotalSize, getGOTEntrySize(),
                                                GOTSectionID, ".got", false);
    if (!Addr)
      return make_error<RuntimeDyldError>("Unable to allocate memory for GOT!");

    Sections[GOTSectionID] =
        SectionEntry(".got", Addr, TotalSize, TotalSize, 0);

    // For now, initialize all GOT entries to zero.  We'll fill them in as
    // needed when GOT-based relocations are applied.
    memset(Addr, 0, TotalSize);
    if (IsMipsN32ABI || IsMipsN64ABI) {
      // To correctly resolve Mips GOT relocations, we need a mapping from
      // object's sections to GOTs.
      for (section_iterator SI = Obj.section_begin(), SE = Obj.section_end();
           SI != SE; ++SI) {
        if (SI->relocation_begin() != SI->relocation_end()) {
          Expected<section_iterator> RelSecOrErr = SI->getRelocatedSection();
          if (!RelSecOrErr)
            return make_error<RuntimeDyldError>(
                toString(RelSecOrErr.takeError()));

          section_iterator RelocatedSection = *RelSecOrErr;
          ObjSectionToIDMap::iterator i = SectionMap.find(*RelocatedSection);
          assert (i != SectionMap.end());
          SectionToGOTMap[i->second] = GOTSectionID;
        }
      }
      GOTSymbolOffsets.clear();
    }
  }

  // Look for and record the EH frame section.
  ObjSectionToIDMap::iterator i, e;
  for (i = SectionMap.begin(), e = SectionMap.end(); i != e; ++i) {
    const SectionRef &Section = i->first;

    StringRef Name;
    Expected<StringRef> NameOrErr = Section.getName();
    if (NameOrErr)
      Name = *NameOrErr;
    else
      consumeError(NameOrErr.takeError());

    if (Name == ".eh_frame") {
      UnregisteredEHFrameSections.push_back(i->second);
      break;
    }
  }

  GOTSectionID = 0;
  CurrentGOTIndex = 0;

  return Error::success();
}

bool RuntimeDyldELF::isCompatibleFile(const object::ObjectFile &Obj) const {
  return Obj.isELF();
}

bool RuntimeDyldELF::relocationNeedsGot(const RelocationRef &R) const {
  unsigned RelTy = R.getType();
  if (Arch == Triple::aarch64 || Arch == Triple::aarch64_be)
    return RelTy == ELF::R_AARCH64_ADR_GOT_PAGE ||
           RelTy == ELF::R_AARCH64_LD64_GOT_LO12_NC;

  if (Arch == Triple::x86_64)
    return RelTy == ELF::R_X86_64_GOTPCREL ||
           RelTy == ELF::R_X86_64_GOTPCRELX ||
           RelTy == ELF::R_X86_64_GOT64 ||
           RelTy == ELF::R_X86_64_REX_GOTPCRELX;
  return false;
}

bool RuntimeDyldELF::relocationNeedsStub(const RelocationRef &R) const {
  if (Arch != Triple::x86_64)
    return true;  // Conservative answer

  switch (R.getType()) {
  default:
    return true;  // Conservative answer


  case ELF::R_X86_64_GOTPCREL:
  case ELF::R_X86_64_GOTPCRELX:
  case ELF::R_X86_64_REX_GOTPCRELX:
  case ELF::R_X86_64_GOTPC64:
  case ELF::R_X86_64_GOT64:
  case ELF::R_X86_64_GOTOFF64:
  case ELF::R_X86_64_PC32:
  case ELF::R_X86_64_PC64:
  case ELF::R_X86_64_64:
    // We know that these reloation types won't need a stub function.  This list
    // can be extended as needed.
    return false;
  }
}

} // namespace llvm
