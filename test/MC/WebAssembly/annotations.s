# RUN: llvm-mc -triple=wasm32-unknown-unknown -mattr=+exception-handling < %s | FileCheck %s

# Tests if block/loop/try/catch/end/branch/rethrow instructions are correctly
# printed with their annotations.

  .text
  .section .text.test_annotation,"",@
  .type    test_annotation,@function
test_annotation:
  .functype   test_annotation () -> ()
  .eventtype  __cpp_exception i32
  try
  br        0
  catch     __cpp_exception
  block
  br_if     0
  loop
  br_if     1
  end_loop
  end_block
  try
  rethrow   0
  catch     __cpp_exception
  block
  try
  br        0
  catch     __cpp_exception
  local.set 0
  end_try
  end_block
  rethrow   0
  end_try
  end_try
  end_function


# CHECK:      test_annotation:
# CHECK:        try
# CHECK-NEXT:   br        0               # 0: down to label0
# CHECK-NEXT:   catch     __cpp_exception # catch0:
# CHECK-NEXT:   block
# CHECK-NEXT:   br_if     0               # 0: down to label1
# CHECK-NEXT:   loop                      # label2:
# CHECK-NEXT:   br_if     1               # 1: down to label1
# CHECK-NEXT:   end_loop
# CHECK-NEXT:   end_block                 # label1:
# CHECK-NEXT:   try
# CHECK-NEXT:   rethrow   0               # down to catch1
# CHECK-NEXT:   catch     __cpp_exception # catch1:
# CHECK-NEXT:   block
# CHECK-NEXT:   try
# CHECK-NEXT:   br        0               # 0: down to label5
# CHECK-NEXT:   catch     __cpp_exception # catch2:
# CHECK-NEXT:   local.set 0
# CHECK-NEXT:   end_try                   # label5:
# CHECK-NEXT:   end_block                 # label4:
# CHECK-NEXT:   rethrow   0               # to caller
# CHECK-NEXT:   end_try                   # label3:
# CHECK-NEXT:   end_try                   # label0:
# CHECK-NEXT:   end_function

