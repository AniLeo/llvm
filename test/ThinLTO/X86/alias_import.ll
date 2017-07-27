; RUN: opt -module-summary %s -o %t1.bc
; RUN: opt -module-summary %p/Inputs/alias_import.ll -o %t2.bc
; RUN: llvm-lto -thinlto-action=thinlink -o %t.index.bc %t1.bc %t2.bc
; RUN: llvm-lto -thinlto-action=promote -thinlto-index %t.index.bc %t2.bc -o - | llvm-dis -o - | FileCheck %s --check-prefix=PROMOTE
; RUN: llvm-lto -thinlto-action=import -thinlto-index %t.index.bc %t1.bc -o - | llvm-dis -o - | FileCheck %s --check-prefix=IMPORT

; Alias can't point to "available_externally", so they cannot be imported for
; now. This could be implemented by importing the alias as an
; available_externally definition copied from the aliasee's body.
; PROMOTE-DAG: @globalfuncAlias = alias void (...), bitcast (void ()* @globalfunc to void (...)*)
; PROMOTE-DAG: @globalfuncWeakAlias = weak alias void (...), bitcast (void ()* @globalfunc to void (...)*)
; PROMOTE-DAG: @globalfuncLinkonceAlias = weak alias void (...), bitcast (void ()* @globalfunc to void (...)*)
; PROMOTE-DAG: @globalfuncWeakODRAlias = weak_odr alias void (...), bitcast (void ()* @globalfunc to void (...)*)
; PROMOTE-DAG: @globalfuncLinkonceODRAlias = weak_odr alias void (...), bitcast (void ()* @globalfunc to void (...)*)
; PROMOTE-DAG: @internalfuncAlias = alias void (...), bitcast (void ()* @internalfunc to void (...)*)
; PROMOTE-DAG: @internalfuncWeakAlias = weak alias void (...), bitcast (void ()* @internalfunc to void (...)*)
; PROMOTE-DAG: @internalfuncLinkonceAlias = weak alias void (...), bitcast (void ()* @internalfunc to void (...)*)
; PROMOTE-DAG: @internalfuncWeakODRAlias = weak_odr alias void (...), bitcast (void ()* @internalfunc to void (...)*)
; PROMOTE-DAG: @internalfuncLinkonceODRAlias = weak_odr alias void (...), bitcast (void ()* @internalfunc to void (...)*)
; PROMOTE-DAG: @linkoncefuncAlias = alias void (...), bitcast (void ()* @linkoncefunc to void (...)*)
; PROMOTE-DAG: @linkoncefuncWeakAlias = weak alias void (...), bitcast (void ()* @linkoncefunc to void (...)*)
; PROMOTE-DAG: @linkoncefuncLinkonceAlias = weak alias void (...), bitcast (void ()* @linkoncefunc to void (...)*)
; PROMOTE-DAG: @linkoncefuncWeakODRAlias = weak_odr alias void (...), bitcast (void ()* @linkoncefunc to void (...)*)
; PROMOTE-DAG: @linkoncefuncLinkonceODRAlias = weak_odr alias void (...), bitcast (void ()* @linkoncefunc to void (...)*)
; PROMOTE-DAG: @weakfuncAlias = alias void (...), bitcast (void ()* @weakfunc to void (...)*)
; PROMOTE-DAG: @weakfuncWeakAlias = weak alias void (...), bitcast (void ()* @weakfunc to void (...)*)
; PROMOTE-DAG: @weakfuncLinkonceAlias = weak alias void (...), bitcast (void ()* @weakfunc to void (...)*)
; PROMOTE-DAG: @weakfuncWeakODRAlias = weak_odr alias void (...), bitcast (void ()* @weakfunc to void (...)*)
; PROMOTE-DAG: @weakfuncLinkonceODRAlias = weak_odr alias void (...), bitcast (void ()* @weakfunc to void (...)*)
; PROMOTE-DAG: @weakODRfuncAlias = alias void (...), bitcast (void ()* @weakODRfunc to void (...)*)
; PROMOTE-DAG: @weakODRfuncWeakAlias = weak alias void (...), bitcast (void ()* @weakODRfunc to void (...)*)
; PROMOTE-DAG: @weakODRfuncLinkonceAlias = weak alias void (...), bitcast (void ()* @weakODRfunc to void (...)*)
; PROMOTE-DAG: @weakODRfuncWeakODRAlias = weak_odr alias void (...), bitcast (void ()* @weakODRfunc to void (...)*)
; PROMOTE-DAG: @weakODRfuncLinkonceODRAlias = weak_odr alias void (...), bitcast (void ()* @weakODRfunc to void (...)*)
; PROMOTE-DAG: @linkonceODRfuncAlias = alias void (...), bitcast (void ()* @linkonceODRfunc to void (...)*)
; PROMOTE-DAG: @linkonceODRfuncWeakAlias = weak alias void (...), bitcast (void ()* @linkonceODRfunc to void (...)*)
; PROMOTE-DAG: @linkonceODRfuncWeakODRAlias = weak_odr alias void (...), bitcast (void ()* @linkonceODRfunc to void (...)*)
; PROMOTE-DAG: @linkonceODRfuncLinkonceAlias = weak alias void (...), bitcast (void ()* @linkonceODRfunc to void (...)*)
; PROMOTE-DAG: @linkonceODRfuncLinkonceODRAlias = weak_odr alias void (...), bitcast (void ()* @linkonceODRfunc to void (...)*)

; PROMOTE-DAG: define void @globalfunc()
; PROMOTE-DAG: define internal void @internalfunc()
; PROMOTE-DAG: define weak_odr void @linkonceODRfunc()
; PROMOTE-DAG: define weak_odr void @weakODRfunc()
; PROMOTE-DAG: define weak void @linkoncefunc()
; PROMOTE-DAG: define weak void @weakfunc()

; On the import side now, verify that aliases are not imported
; IMPORT-DAG:  declare void @linkonceODRfuncWeakAlias
; IMPORT-DAG:  declare void @linkonceODRfuncLinkonceAlias
; IMPORT-DAG:  declare void @linkonceODRfuncAlias
; IMPORT-DAG:  declare void @linkonceODRfuncWeakODRAlias
; IMPORT-DAG:  declare void @linkonceODRfuncLinkonceODRAlias


; On the import side, these aliases are not imported (they don't point to a linkonce_odr)
; IMPORT-DAG: declare void @globalfuncAlias()
; IMPORT-DAG: declare void @globalfuncWeakAlias()
; IMPORT-DAG: declare void @globalfuncLinkonceAlias()
; IMPORT-DAG: declare void @globalfuncWeakODRAlias()
; IMPORT-DAG: declare void @globalfuncLinkonceODRAlias()
; IMPORT-DAG: declare void @internalfuncAlias()
; IMPORT-DAG: declare void @internalfuncWeakAlias()
; IMPORT-DAG: declare void @internalfuncLinkonceAlias()
; IMPORT-DAG: declare void @internalfuncWeakODRAlias()
; IMPORT-DAG: declare void @internalfuncLinkonceODRAlias()
; IMPORT-DAG: declare void @weakODRfuncAlias()
; IMPORT-DAG: declare void @weakODRfuncWeakAlias()
; IMPORT-DAG: declare void @weakODRfuncLinkonceAlias()
; IMPORT-DAG: declare void @weakODRfuncWeakODRAlias()
; IMPORT-DAG: declare void @weakODRfuncLinkonceODRAlias()
; IMPORT-DAG: declare void @linkoncefuncAlias()
; IMPORT-DAG: declare void @linkoncefuncWeakAlias()
; IMPORT-DAG: declare void @linkoncefuncLinkonceAlias()
; IMPORT-DAG: declare void @linkoncefuncWeakODRAlias()
; IMPORT-DAG: declare void @linkoncefuncLinkonceODRAlias()
; IMPORT-DAG: declare void @weakfuncAlias()
; IMPORT-DAG: declare void @weakfuncWeakAlias()
; IMPORT-DAG: declare void @weakfuncLinkonceAlias()
; IMPORT-DAG: declare void @weakfuncWeakODRAlias()
; IMPORT-DAG: declare void @weakfuncLinkonceODRAlias()
; IMPORT-DAG: declare void @linkonceODRfuncAlias()
; IMPORT-DAG: declare void @linkonceODRfuncWeakAlias()
; IMPORT-DAG: declare void @linkonceODRfuncWeakODRAlias()
; IMPORT-DAG: declare void @linkonceODRfuncLinkonceAlias()
; IMPORT-DAG: declare void @linkonceODRfuncLinkonceODRAlias()

define i32 @main() #0 {
entry:
  call void @globalfuncAlias()
  call void @globalfuncWeakAlias()
  call void @globalfuncLinkonceAlias()
  call void @globalfuncWeakODRAlias()
  call void @globalfuncLinkonceODRAlias()

  call void @internalfuncAlias()
  call void @internalfuncWeakAlias()
  call void @internalfuncLinkonceAlias()
  call void @internalfuncWeakODRAlias()
  call void @internalfuncLinkonceODRAlias()
  call void @linkonceODRfuncAlias()
  call void @linkonceODRfuncWeakAlias()
  call void @linkonceODRfuncLinkonceAlias()
  call void @linkonceODRfuncWeakODRAlias()
  call void @linkonceODRfuncLinkonceODRAlias()

  call void @weakODRfuncAlias()
  call void @weakODRfuncWeakAlias()
  call void @weakODRfuncLinkonceAlias()
  call void @weakODRfuncWeakODRAlias()
  call void @weakODRfuncLinkonceODRAlias()

  call void @linkoncefuncAlias()
  call void @linkoncefuncWeakAlias()
  call void @linkoncefuncLinkonceAlias()
  call void @linkoncefuncWeakODRAlias()
  call void @linkoncefuncLinkonceODRAlias()

  call void @weakfuncAlias()
  call void @weakfuncWeakAlias()
  call void @weakfuncLinkonceAlias()
  call void @weakfuncWeakODRAlias()
  call void @weakfuncLinkonceODRAlias()

  ret i32 0
}


declare void @globalfuncAlias()
declare void @globalfuncWeakAlias()
declare void @globalfuncLinkonceAlias()
declare void @globalfuncWeakODRAlias()
declare void @globalfuncLinkonceODRAlias()

declare void @internalfuncAlias()
declare void @internalfuncWeakAlias()
declare void @internalfuncLinkonceAlias()
declare void @internalfuncWeakODRAlias()
declare void @internalfuncLinkonceODRAlias()

declare void @linkonceODRfuncAlias()
declare void @linkonceODRfuncWeakAlias()
declare void @linkonceODRfuncLinkonceAlias()
declare void @linkonceODRfuncWeakODRAlias()
declare void @linkonceODRfuncLinkonceODRAlias()

declare void @weakODRfuncAlias()
declare void @weakODRfuncWeakAlias()
declare void @weakODRfuncLinkonceAlias()
declare void @weakODRfuncWeakODRAlias()
declare void @weakODRfuncLinkonceODRAlias()

declare void @linkoncefuncAlias()
declare void @linkoncefuncWeakAlias()
declare void @linkoncefuncLinkonceAlias()
declare void @linkoncefuncWeakODRAlias()
declare void @linkoncefuncLinkonceODRAlias()

declare void @weakfuncAlias()
declare void @weakfuncWeakAlias()
declare void @weakfuncLinkonceAlias()
declare void @weakfuncWeakODRAlias()
declare void @weakfuncLinkonceODRAlias()


