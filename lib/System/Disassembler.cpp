//===- lib/System/Disassembler.cpp ------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file was developed by Anton Korobeynikov and is distributed under the
// University of Illinois Open Source License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the necessary glue to call external disassembler
// libraries.
//
//===----------------------------------------------------------------------===//

#include "llvm/Config/config.h"
#include "llvm/System/Disassembler.h"

#include <cassert>
#include <iomanip>
#include <string>
#include <sstream>

#if USE_UDIS86
#include <udis86.h>
#endif

using namespace llvm;

std::string llvm::sys::disassembleBuffer(uint8_t* start, size_t length,
                                         uint64_t pc) {
  std::stringstream res;

#if defined (__i386__) || defined (__amd64__) || defined (__x86_64__)
  unsigned bits;
# if defined(__i386__)
  bits = 32;
# else
  bits = 64;
# endif
  
# if USE_UDIS86
  ud_t ud_obj;
   
  ud_init(&ud_obj);
  ud_set_input_buffer(&ud_obj, start, length);
  ud_set_mode(&ud_obj, bits);
  ud_set_pc(&ud_obj, pc);
  ud_set_syntax(&ud_obj, UD_SYN_ATT);
  
  res << std::setbase(16)
      << std::setw(bits/4);
  
  while (ud_disassemble(&ud_obj)) {
    res << ud_insn_off(&ud_obj) << ":\t" << ud_insn_asm(&ud_obj) << "\n";
  }
# else
  res << "No disassembler available. See configure help for avaiable options.\n";
# endif
  
#else
  res << "No disassembler available. See configure help for avaiable options.\n";
#endif

  return res.str();
}
