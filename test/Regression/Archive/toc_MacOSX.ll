;This isn't really an assembly file, its just here to run the test.
;This test just makes sure that llvm-ar can generate a table of contents for
;MacOSX style archives
;RUN: llvm-ar t %p/MacOSX.a > %t1
;RUN: grep -v '^;' %s >%t2
;RUN: diff %t2 %t1
__.SYMDEF SORTED    
evenlen     
oddlen      
very_long_bytecode_file_name.bc     
IsNAN.o     
