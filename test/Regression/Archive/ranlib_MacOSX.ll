;This isn't really an assembly file, its just here to run the test.
;This test just makes sure that llvm-ar can generate a symbol table for
;MacOSX style archives
;RUN: cp %p/MacOSX.a %t.MacOSX.a 
;RUN: llvm-ranlib %t.MacOSX.a
;RUN: llvm-ar t %t.MacOSX.a > %t1
;RUN: grep -v '^;' %s >%t2
;RUN: diff %t2 %t1
__.SYMDEF SORTED    
evenlen     
oddlen      
very_long_bytecode_file_name.bc     
IsNAN.o     
