//===- ELFObjectFile.cpp - ELF object file implementation -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Part of the ELFObjectFile class implementation.
//
//===----------------------------------------------------------------------===//

#include "llvm/Object/ELFObjectFile.h"
#include "llvm/ADT/Triple.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/SubtargetFeature.h"
#include "llvm/Object/ELF.h"
#include "llvm/Object/ELFTypes.h"
#include "llvm/Object/Error.h"
#include "llvm/Support/ARMAttributeParser.h"
#include "llvm/Support/ARMBuildAttributes.h"
#include "llvm/Support/Endian.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/RISCVAttributeParser.h"
#include "llvm/Support/RISCVAttributes.h"
#include "llvm/Support/TargetRegistry.h"
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <memory>
#include <string>
#include <system_error>
#include <utility>

using namespace llvm;
using namespace object;

const EnumEntry<unsigned> llvm::object::ElfSymbolTypes[NumElfSymbolTypes] = {
    {"None", "NOTYPE", ELF::STT_NOTYPE},
    {"Object", "OBJECT", ELF::STT_OBJECT},
    {"Function", "FUNC", ELF::STT_FUNC},
    {"Section", "SECTION", ELF::STT_SECTION},
    {"File", "FILE", ELF::STT_FILE},
    {"Common", "COMMON", ELF::STT_COMMON},
    {"TLS", "TLS", ELF::STT_TLS},
    {"Unknown", "<unknown>: 7", 7},
    {"Unknown", "<unknown>: 8", 8},
    {"Unknown", "<unknown>: 9", 9},
    {"GNU_IFunc", "IFUNC", ELF::STT_GNU_IFUNC},
    {"OS Specific", "<OS specific>: 11", 11},
    {"OS Specific", "<OS specific>: 12", 12},
    {"Proc Specific", "<processor specific>: 13", 13},
    {"Proc Specific", "<processor specific>: 14", 14},
    {"Proc Specific", "<processor specific>: 15", 15}
};

ELFObjectFileBase::ELFObjectFileBase(unsigned int Type, MemoryBufferRef Source)
    : ObjectFile(Type, Source) {}

template <class ELFT>
static Expected<std::unique_ptr<ELFObjectFile<ELFT>>>
createPtr(MemoryBufferRef Object) {
  auto Ret = ELFObjectFile<ELFT>::create(Object);
  if (Error E = Ret.takeError())
    return std::move(E);
  return std::make_unique<ELFObjectFile<ELFT>>(std::move(*Ret));
}

Expected<std::unique_ptr<ObjectFile>>
ObjectFile::createELFObjectFile(MemoryBufferRef Obj) {
  std::pair<unsigned char, unsigned char> Ident =
      getElfArchType(Obj.getBuffer());
  std::size_t MaxAlignment =
      1ULL << countTrailingZeros(uintptr_t(Obj.getBufferStart()));

  if (MaxAlignment < 2)
    return createError("Insufficient alignment");

  if (Ident.first == ELF::ELFCLASS32) {
    if (Ident.second == ELF::ELFDATA2LSB)
      return createPtr<ELF32LE>(Obj);
    else if (Ident.second == ELF::ELFDATA2MSB)
      return createPtr<ELF32BE>(Obj);
    else
      return createError("Invalid ELF data");
  } else if (Ident.first == ELF::ELFCLASS64) {
    if (Ident.second == ELF::ELFDATA2LSB)
      return createPtr<ELF64LE>(Obj);
    else if (Ident.second == ELF::ELFDATA2MSB)
      return createPtr<ELF64BE>(Obj);
    else
      return createError("Invalid ELF data");
  }
  return createError("Invalid ELF class");
}

SubtargetFeatures ELFObjectFileBase::getMIPSFeatures() const {
  SubtargetFeatures Features;
  unsigned PlatformFlags = getPlatformFlags();

  switch (PlatformFlags & ELF::EF_MIPS_ARCH) {
  case ELF::EF_MIPS_ARCH_1:
    break;
  case ELF::EF_MIPS_ARCH_2:
    Features.AddFeature("mips2");
    break;
  case ELF::EF_MIPS_ARCH_3:
    Features.AddFeature("mips3");
    break;
  case ELF::EF_MIPS_ARCH_4:
    Features.AddFeature("mips4");
    break;
  case ELF::EF_MIPS_ARCH_5:
    Features.AddFeature("mips5");
    break;
  case ELF::EF_MIPS_ARCH_32:
    Features.AddFeature("mips32");
    break;
  case ELF::EF_MIPS_ARCH_64:
    Features.AddFeature("mips64");
    break;
  case ELF::EF_MIPS_ARCH_32R2:
    Features.AddFeature("mips32r2");
    break;
  case ELF::EF_MIPS_ARCH_64R2:
    Features.AddFeature("mips64r2");
    break;
  case ELF::EF_MIPS_ARCH_32R6:
    Features.AddFeature("mips32r6");
    break;
  case ELF::EF_MIPS_ARCH_64R6:
    Features.AddFeature("mips64r6");
    break;
  default:
    llvm_unreachable("Unknown EF_MIPS_ARCH value");
  }

  switch (PlatformFlags & ELF::EF_MIPS_MACH) {
  case ELF::EF_MIPS_MACH_NONE:
    // No feature associated with this value.
    break;
  case ELF::EF_MIPS_MACH_OCTEON:
    Features.AddFeature("cnmips");
    break;
  default:
    llvm_unreachable("Unknown EF_MIPS_ARCH value");
  }

  if (PlatformFlags & ELF::EF_MIPS_ARCH_ASE_M16)
    Features.AddFeature("mips16");
  if (PlatformFlags & ELF::EF_MIPS_MICROMIPS)
    Features.AddFeature("micromips");

  return Features;
}

SubtargetFeatures ELFObjectFileBase::getARMFeatures() const {
  SubtargetFeatures Features;
  ARMAttributeParser Attributes;
  if (Error E = getBuildAttributes(Attributes)) {
    consumeError(std::move(E));
    return SubtargetFeatures();
  }

  // both ARMv7-M and R have to support thumb hardware div
  bool isV7 = false;
  Optional<unsigned> Attr =
      Attributes.getAttributeValue(ARMBuildAttrs::CPU_arch);
  if (Attr.hasValue())
    isV7 = Attr.getValue() == ARMBuildAttrs::v7;

  Attr = Attributes.getAttributeValue(ARMBuildAttrs::CPU_arch_profile);
  if (Attr.hasValue()) {
    switch (Attr.getValue()) {
    case ARMBuildAttrs::ApplicationProfile:
      Features.AddFeature("aclass");
      break;
    case ARMBuildAttrs::RealTimeProfile:
      Features.AddFeature("rclass");
      if (isV7)
        Features.AddFeature("hwdiv");
      break;
    case ARMBuildAttrs::MicroControllerProfile:
      Features.AddFeature("mclass");
      if (isV7)
        Features.AddFeature("hwdiv");
      break;
    }
  }

  Attr = Attributes.getAttributeValue(ARMBuildAttrs::THUMB_ISA_use);
  if (Attr.hasValue()) {
    switch (Attr.getValue()) {
    default:
      break;
    case ARMBuildAttrs::Not_Allowed:
      Features.AddFeature("thumb", false);
      Features.AddFeature("thumb2", false);
      break;
    case ARMBuildAttrs::AllowThumb32:
      Features.AddFeature("thumb2");
      break;
    }
  }

  Attr = Attributes.getAttributeValue(ARMBuildAttrs::FP_arch);
  if (Attr.hasValue()) {
    switch (Attr.getValue()) {
    default:
      break;
    case ARMBuildAttrs::Not_Allowed:
      Features.AddFeature("vfp2sp", false);
      Features.AddFeature("vfp3d16sp", false);
      Features.AddFeature("vfp4d16sp", false);
      break;
    case ARMBuildAttrs::AllowFPv2:
      Features.AddFeature("vfp2");
      break;
    case ARMBuildAttrs::AllowFPv3A:
    case ARMBuildAttrs::AllowFPv3B:
      Features.AddFeature("vfp3");
      break;
    case ARMBuildAttrs::AllowFPv4A:
    case ARMBuildAttrs::AllowFPv4B:
      Features.AddFeature("vfp4");
      break;
    }
  }

  Attr = Attributes.getAttributeValue(ARMBuildAttrs::Advanced_SIMD_arch);
  if (Attr.hasValue()) {
    switch (Attr.getValue()) {
    default:
      break;
    case ARMBuildAttrs::Not_Allowed:
      Features.AddFeature("neon", false);
      Features.AddFeature("fp16", false);
      break;
    case ARMBuildAttrs::AllowNeon:
      Features.AddFeature("neon");
      break;
    case ARMBuildAttrs::AllowNeon2:
      Features.AddFeature("neon");
      Features.AddFeature("fp16");
      break;
    }
  }

  Attr = Attributes.getAttributeValue(ARMBuildAttrs::MVE_arch);
  if (Attr.hasValue()) {
    switch (Attr.getValue()) {
    default:
      break;
    case ARMBuildAttrs::Not_Allowed:
      Features.AddFeature("mve", false);
      Features.AddFeature("mve.fp", false);
      break;
    case ARMBuildAttrs::AllowMVEInteger:
      Features.AddFeature("mve.fp", false);
      Features.AddFeature("mve");
      break;
    case ARMBuildAttrs::AllowMVEIntegerAndFloat:
      Features.AddFeature("mve.fp");
      break;
    }
  }

  Attr = Attributes.getAttributeValue(ARMBuildAttrs::DIV_use);
  if (Attr.hasValue()) {
    switch (Attr.getValue()) {
    default:
      break;
    case ARMBuildAttrs::DisallowDIV:
      Features.AddFeature("hwdiv", false);
      Features.AddFeature("hwdiv-arm", false);
      break;
    case ARMBuildAttrs::AllowDIVExt:
      Features.AddFeature("hwdiv");
      Features.AddFeature("hwdiv-arm");
      break;
    }
  }

  return Features;
}

SubtargetFeatures ELFObjectFileBase::getRISCVFeatures() const {
  SubtargetFeatures Features;
  unsigned PlatformFlags = getPlatformFlags();

  if (PlatformFlags & ELF::EF_RISCV_RVC) {
    Features.AddFeature("c");
  }

  // Add features according to the ELF attribute section.
  // If there are any unrecognized features, ignore them.
  RISCVAttributeParser Attributes;
  if (Error E = getBuildAttributes(Attributes)) {
    // TODO Propagate Error.
    consumeError(std::move(E));
    return Features; // Keep "c" feature if there is one in PlatformFlags.
  }

  Optional<StringRef> Attr = Attributes.getAttributeString(RISCVAttrs::ARCH);
  if (Attr.hasValue()) {
    // The Arch pattern is [rv32|rv64][i|e]version(_[m|a|f|d|c]version)*
    // Version string pattern is (major)p(minor). Major and minor are optional.
    // For example, a version number could be 2p0, 2, or p92.
    StringRef Arch = Attr.getValue();
    if (Arch.consume_front("rv32"))
      Features.AddFeature("64bit", false);
    else if (Arch.consume_front("rv64"))
      Features.AddFeature("64bit");

    while (!Arch.empty()) {
      switch (Arch[0]) {
      default:
        break; // Ignore unexpected features.
      case 'i':
        Features.AddFeature("e", false);
        break;
      case 'd':
        Features.AddFeature("f"); // D-ext will imply F-ext.
        LLVM_FALLTHROUGH;
      case 'e':
      case 'm':
      case 'a':
      case 'f':
      case 'c':
        Features.AddFeature(Arch.take_front());
        break;
      }

      // FIXME: Handle version numbers.
      Arch = Arch.drop_until([](char c) { return c == '_' || c == '\0'; });
      Arch = Arch.drop_while([](char c) { return c == '_'; });
    }
  }

  return Features;
}

SubtargetFeatures ELFObjectFileBase::getFeatures() const {
  switch (getEMachine()) {
  case ELF::EM_MIPS:
    return getMIPSFeatures();
  case ELF::EM_ARM:
    return getARMFeatures();
  case ELF::EM_RISCV:
    return getRISCVFeatures();
  default:
    return SubtargetFeatures();
  }
}

Optional<StringRef> ELFObjectFileBase::tryGetCPUName() const {
  switch (getEMachine()) {
  case ELF::EM_AMDGPU:
    return getAMDGPUCPUName();
  default:
    return None;
  }
}

StringRef ELFObjectFileBase::getAMDGPUCPUName() const {
  assert(getEMachine() == ELF::EM_AMDGPU);
  unsigned CPU = getPlatformFlags() & ELF::EF_AMDGPU_MACH;

  switch (CPU) {
  // Radeon HD 2000/3000 Series (R600).
  case ELF::EF_AMDGPU_MACH_R600_R600:
    return "r600";
  case ELF::EF_AMDGPU_MACH_R600_R630:
    return "r630";
  case ELF::EF_AMDGPU_MACH_R600_RS880:
    return "rs880";
  case ELF::EF_AMDGPU_MACH_R600_RV670:
    return "rv670";

  // Radeon HD 4000 Series (R700).
  case ELF::EF_AMDGPU_MACH_R600_RV710:
    return "rv710";
  case ELF::EF_AMDGPU_MACH_R600_RV730:
    return "rv730";
  case ELF::EF_AMDGPU_MACH_R600_RV770:
    return "rv770";

  // Radeon HD 5000 Series (Evergreen).
  case ELF::EF_AMDGPU_MACH_R600_CEDAR:
    return "cedar";
  case ELF::EF_AMDGPU_MACH_R600_CYPRESS:
    return "cypress";
  case ELF::EF_AMDGPU_MACH_R600_JUNIPER:
    return "juniper";
  case ELF::EF_AMDGPU_MACH_R600_REDWOOD:
    return "redwood";
  case ELF::EF_AMDGPU_MACH_R600_SUMO:
    return "sumo";

  // Radeon HD 6000 Series (Northern Islands).
  case ELF::EF_AMDGPU_MACH_R600_BARTS:
    return "barts";
  case ELF::EF_AMDGPU_MACH_R600_CAICOS:
    return "caicos";
  case ELF::EF_AMDGPU_MACH_R600_CAYMAN:
    return "cayman";
  case ELF::EF_AMDGPU_MACH_R600_TURKS:
    return "turks";

  // AMDGCN GFX6.
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX600:
    return "gfx600";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX601:
    return "gfx601";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX602:
    return "gfx602";

  // AMDGCN GFX7.
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX700:
    return "gfx700";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX701:
    return "gfx701";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX702:
    return "gfx702";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX703:
    return "gfx703";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX704:
    return "gfx704";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX705:
    return "gfx705";

  // AMDGCN GFX8.
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX801:
    return "gfx801";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX802:
    return "gfx802";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX803:
    return "gfx803";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX805:
    return "gfx805";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX810:
    return "gfx810";

  // AMDGCN GFX9.
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX900:
    return "gfx900";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX902:
    return "gfx902";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX904:
    return "gfx904";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX906:
    return "gfx906";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX908:
    return "gfx908";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX909:
    return "gfx909";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX90C:
    return "gfx90c";

  // AMDGCN GFX10.
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX1010:
    return "gfx1010";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX1011:
    return "gfx1011";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX1012:
    return "gfx1012";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX1030:
    return "gfx1030";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX1031:
    return "gfx1031";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX1032:
    return "gfx1032";
  case ELF::EF_AMDGPU_MACH_AMDGCN_GFX1033:
    return "gfx1033";
  default:
    llvm_unreachable("Unknown EF_AMDGPU_MACH value");
  }
}

// FIXME Encode from a tablegen description or target parser.
void ELFObjectFileBase::setARMSubArch(Triple &TheTriple) const {
  if (TheTriple.getSubArch() != Triple::NoSubArch)
    return;

  ARMAttributeParser Attributes;
  if (Error E = getBuildAttributes(Attributes)) {
    // TODO Propagate Error.
    consumeError(std::move(E));
    return;
  }

  std::string Triple;
  // Default to ARM, but use the triple if it's been set.
  if (TheTriple.isThumb())
    Triple = "thumb";
  else
    Triple = "arm";

  Optional<unsigned> Attr =
      Attributes.getAttributeValue(ARMBuildAttrs::CPU_arch);
  if (Attr.hasValue()) {
    switch (Attr.getValue()) {
    case ARMBuildAttrs::v4:
      Triple += "v4";
      break;
    case ARMBuildAttrs::v4T:
      Triple += "v4t";
      break;
    case ARMBuildAttrs::v5T:
      Triple += "v5t";
      break;
    case ARMBuildAttrs::v5TE:
      Triple += "v5te";
      break;
    case ARMBuildAttrs::v5TEJ:
      Triple += "v5tej";
      break;
    case ARMBuildAttrs::v6:
      Triple += "v6";
      break;
    case ARMBuildAttrs::v6KZ:
      Triple += "v6kz";
      break;
    case ARMBuildAttrs::v6T2:
      Triple += "v6t2";
      break;
    case ARMBuildAttrs::v6K:
      Triple += "v6k";
      break;
    case ARMBuildAttrs::v7:
      Triple += "v7";
      break;
    case ARMBuildAttrs::v6_M:
      Triple += "v6m";
      break;
    case ARMBuildAttrs::v6S_M:
      Triple += "v6sm";
      break;
    case ARMBuildAttrs::v7E_M:
      Triple += "v7em";
      break;
    case ARMBuildAttrs::v8_A:
      Triple += "v8a";
      break;
    case ARMBuildAttrs::v8_R:
      Triple += "v8r";
      break;
    case ARMBuildAttrs::v8_M_Base:
      Triple += "v8m.base";
      break;
    case ARMBuildAttrs::v8_M_Main:
      Triple += "v8m.main";
      break;
    case ARMBuildAttrs::v8_1_M_Main:
      Triple += "v8.1m.main";
      break;
    }
  }
  if (!isLittleEndian())
    Triple += "eb";

  TheTriple.setArchName(Triple);
}

std::vector<std::pair<Optional<DataRefImpl>, uint64_t>>
ELFObjectFileBase::getPltAddresses() const {
  std::string Err;
  const auto Triple = makeTriple();
  const auto *T = TargetRegistry::lookupTarget(Triple.str(), Err);
  if (!T)
    return {};
  uint64_t JumpSlotReloc = 0;
  switch (Triple.getArch()) {
    case Triple::x86:
      JumpSlotReloc = ELF::R_386_JUMP_SLOT;
      break;
    case Triple::x86_64:
      JumpSlotReloc = ELF::R_X86_64_JUMP_SLOT;
      break;
    case Triple::aarch64:
      JumpSlotReloc = ELF::R_AARCH64_JUMP_SLOT;
      break;
    default:
      return {};
  }
  std::unique_ptr<const MCInstrInfo> MII(T->createMCInstrInfo());
  std::unique_ptr<const MCInstrAnalysis> MIA(
      T->createMCInstrAnalysis(MII.get()));
  if (!MIA)
    return {};
  Optional<SectionRef> Plt = None, RelaPlt = None, GotPlt = None;
  for (const SectionRef &Section : sections()) {
    Expected<StringRef> NameOrErr = Section.getName();
    if (!NameOrErr) {
      consumeError(NameOrErr.takeError());
      continue;
    }
    StringRef Name = *NameOrErr;

    if (Name == ".plt")
      Plt = Section;
    else if (Name == ".rela.plt" || Name == ".rel.plt")
      RelaPlt = Section;
    else if (Name == ".got.plt")
      GotPlt = Section;
  }
  if (!Plt || !RelaPlt || !GotPlt)
    return {};
  Expected<StringRef> PltContents = Plt->getContents();
  if (!PltContents) {
    consumeError(PltContents.takeError());
    return {};
  }
  auto PltEntries = MIA->findPltEntries(Plt->getAddress(),
                                        arrayRefFromStringRef(*PltContents),
                                        GotPlt->getAddress(), Triple);
  // Build a map from GOT entry virtual address to PLT entry virtual address.
  DenseMap<uint64_t, uint64_t> GotToPlt;
  for (const auto &Entry : PltEntries)
    GotToPlt.insert(std::make_pair(Entry.second, Entry.first));
  // Find the relocations in the dynamic relocation table that point to
  // locations in the GOT for which we know the corresponding PLT entry.
  std::vector<std::pair<Optional<DataRefImpl>, uint64_t>> Result;
  for (const auto &Relocation : RelaPlt->relocations()) {
    if (Relocation.getType() != JumpSlotReloc)
      continue;
    auto PltEntryIter = GotToPlt.find(Relocation.getOffset());
    if (PltEntryIter != GotToPlt.end()) {
      symbol_iterator Sym = Relocation.getSymbol();
      if (Sym == symbol_end())
        Result.emplace_back(None, PltEntryIter->second);
      else
        Result.emplace_back(Sym->getRawDataRefImpl(), PltEntryIter->second);
    }
  }
  return Result;
}
