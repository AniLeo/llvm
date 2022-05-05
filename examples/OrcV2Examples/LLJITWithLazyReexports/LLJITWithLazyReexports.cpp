//===--- LLJITWithLazyReexports.cpp - LLJIT example with custom laziness --===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// In this example we will use the lazy re-exports utility to lazily compile
// IR modules. We will do this in seven steps:
//
// 1. Create an LLJIT instance.
// 2. Install a transform so that we can see what is being compiled.
// 3. Create an indirect stubs manager and lazy call-through manager.
// 4. Add two modules that will be conditionally compiled, plus a main module.
// 5. Add lazy-rexports of the symbols in the conditionally compiled modules.
// 6. Dump the ExecutionSession state to see the symbol table prior to
//    executing any code.
// 7. Verify that only modules containing executed code are compiled.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/StringMap.h"
#include "llvm/ExecutionEngine/JITLink/JITLinkMemoryManager.h"
#include "llvm/ExecutionEngine/Orc/LLJIT.h"
#include "llvm/ExecutionEngine/Orc/ObjectLinkingLayer.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"

#include "../ExampleModules.h"

using namespace llvm;
using namespace llvm::orc;

ExitOnError ExitOnErr;

// Example IR modules.
//
// Note that in the conditionally compiled modules, FooMod and BarMod, functions
// have been given an _body suffix. This is to ensure that their names do not
// clash with their lazy-reexports.
// For clients who do not wish to rename function bodies (e.g. because they want
// to re-use cached objects between static and JIT compiles) techniques exist to
// avoid renaming. See the lazy-reexports section of the ORCv2 design doc.

const llvm::StringRef FooMod =
    R"(
  define i32 @foo_body() {
  entry:
    ret i32 1
  }
)";

const llvm::StringRef BarMod =
    R"(
  define i32 @bar_body() {
  entry:
    ret i32 2
  }
)";

const llvm::StringRef MainMod =
    R"(

  define i32 @entry(i32 %argc) {
  entry:
    %and = and i32 %argc, 1
    %tobool = icmp eq i32 %and, 0
    br i1 %tobool, label %if.end, label %if.then

  if.then:                                          ; preds = %entry
    %call = tail call i32 @foo() #2
    br label %return

  if.end:                                           ; preds = %entry
    %call1 = tail call i32 @bar() #2
    br label %return

  return:                                           ; preds = %if.end, %if.then
    %retval.0 = phi i32 [ %call, %if.then ], [ %call1, %if.end ]
    ret i32 %retval.0
  }

  declare i32 @foo()
  declare i32 @bar()
)";

cl::list<std::string> InputArgv(cl::Positional,
                                cl::desc("<program arguments>..."));

int main(int argc, char *argv[]) {
  // Initialize LLVM.
  InitLLVM X(argc, argv);

  InitializeNativeTarget();
  InitializeNativeTargetAsmPrinter();

  cl::ParseCommandLineOptions(argc, argv, "LLJITWithLazyReexports");
  ExitOnErr.setBanner(std::string(argv[0]) + ": ");

  // (1) Create LLJIT instance.
  auto J = ExitOnErr(LLJITBuilder().create());

  // (2) Install transform to print modules as they are compiled:
  J->getIRTransformLayer().setTransform(
      [](ThreadSafeModule TSM,
         const MaterializationResponsibility &R) -> Expected<ThreadSafeModule> {
        TSM.withModuleDo([](Module &M) { dbgs() << "---Compiling---\n" << M; });
        return std::move(TSM); // Not a redundant move: fix build on gcc-7.5
      });

  // (3) Create stubs and call-through managers:
  std::unique_ptr<IndirectStubsManager> ISM;
  {
    auto ISMBuilder =
        createLocalIndirectStubsManagerBuilder(J->getTargetTriple());
    if (!ISMBuilder())
      ExitOnErr(make_error<StringError>("Could not create stubs manager for " +
                                            J->getTargetTriple().str(),
                                        inconvertibleErrorCode()));
    ISM = ISMBuilder();
  }
  auto LCTM = ExitOnErr(createLocalLazyCallThroughManager(
      J->getTargetTriple(), J->getExecutionSession(), 0));

  // (4) Add modules.
  ExitOnErr(J->addIRModule(ExitOnErr(parseExampleModule(FooMod, "foo-mod"))));
  ExitOnErr(J->addIRModule(ExitOnErr(parseExampleModule(BarMod, "bar-mod"))));
  ExitOnErr(J->addIRModule(ExitOnErr(parseExampleModule(MainMod, "main-mod"))));

  // (5) Add lazy reexports.
  MangleAndInterner Mangle(J->getExecutionSession(), J->getDataLayout());
  SymbolAliasMap ReExports(
      {{Mangle("foo"),
        {Mangle("foo_body"),
         JITSymbolFlags::Exported | JITSymbolFlags::Callable}},
       {Mangle("bar"),
        {Mangle("bar_body"),
         JITSymbolFlags::Exported | JITSymbolFlags::Callable}}});
  ExitOnErr(J->getMainJITDylib().define(
      lazyReexports(*LCTM, *ISM, J->getMainJITDylib(), std::move(ReExports))));

  // (6) Dump the ExecutionSession state.
  dbgs() << "---Session state---\n";
  J->getExecutionSession().dump(dbgs());
  dbgs() << "\n";

  // (7) Execute the JIT'd main function and pass the example's command line
  // arguments unmodified. This should cause either ExampleMod1 or ExampleMod2
  // to be compiled, and either "1" or "2" returned depending on the number of
  // arguments passed.

  // Look up the JIT'd function, cast it to a function pointer, then call it.
  auto EntryAddr = ExitOnErr(J->lookup("entry"));
  auto *Entry = EntryAddr.toPtr<int(int)>();

  int Result = Entry(argc);
  outs() << "---Result---\n"
         << "entry(" << argc << ") = " << Result << "\n";

  return 0;
}
