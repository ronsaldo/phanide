"
A PhanideGDBOutputParserTest is a test class for testing the behavior of PhanideGDBOutputParser
"
Class {
	#name : #PhanideGDBOutputParserTest,
	#superclass : #TestCase,
	#category : 'Phanide-GDB-Tests'
}

{ #category : #'instance creation' }
PhanideGDBOutputParserTest >> sample [
	^ '=thread-group-added,id="i1"
~"GNU gdb (Ubuntu 7.11.90.20161005-0ubuntu2) 7.11.90.20161005-git\n"
~"Copyright (C) 2016 Free Software Foundation, Inc.\n"
~"License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>\nThis is free software: you are free to change and redistribute it.\nThere is NO WARRANTY, to the extent permitted by law.  Type \"show copying\"\nand \"show warranty\" for details.\n"
~"This GDB was configured as \"x86_64-linux-gnu\".\nType \"show configuration\" for configuration details."
~"\nPara las instrucciones de informe de errores, vea:\n"
~"<http://www.gnu.org/software/gdb/bugs/>.\n"
~"Find the GDB manual and other documentation resources online at:\n<http://www.gnu.org/software/gdb/documentation/>.\n"
~"For help, type \"help\".\n"
~"Type \"apropos word\" to search for commands related to \"word\".\n"
(gdb) 
&"help\n"
~"List of classes of commands:\n\n"
~"aliases -- Alias de otras \303\263rdenes\n"
~"breakpoints -- Para el programa en ciertos puntos\n"
~"data -- Examinando datos\n"
~"files -- Especificando y examinando archivos\n"
~"internals -- \303\223rdenes de mantenimiento\n"
~"obscure -- Ocultar caracter\303\255sticas\n"
~"running -- Corriendo el programa\n"
~"stack -- Examinar la pila\n"
~"status -- Preguntas de estado\n"
~"support -- Facilidades de soporte\n"
~"tracepoints -- Tracing of program execution without stopping the program\n"
~"user-defined -- \303\223rdenes definidas por el usuario\n"
~"\nType \"help\" followed by a class name for a list of commands in "
~"that class.\nType \"help all\" for the list of all commands."
~"\nType \"help\" followed by command name "
~"for full documentation.\n"
~"Type \"apropos word\" to search for commands related to \"word\".\n"
~"Command name abbreviations are allowed if unambiguous.\n"
=library-loaded,id="/lib64/ld-linux-x86-64.so.2",target-name="/lib64/ld-linux-x86-64.so.2",host-name="/lib64/ld-linux-x86-64.so.2",symbols-loaded="0",thread-group="i1",ranges=[{from="0x00007ffff7fd3090",to="0x00007ffff7ff3130"}]
^done
(gdb)'
]

{ #category : #tests }
PhanideGDBOutputParserTest >> testParseStacktrace [
	| record stack frame |
	record := PhanideGDBOutputParser parse: '^done,stack=[frame={level="0",addr="0x0000555555555154",func="main",file="testExample.cpp",fullname="./testExample.cpp",line="5",arch="i386:x86-64"}]'.
	self assert: record resultClass equals: 'done'.
	stack := record results at: #stack.
	self assert: stack size equals: 1.
	self assert: stack first key equals: #frame.
	frame := stack first value.
	self assert: (frame at: #level) equals: '0'.
	self assert: (frame at: #addr) equals: '0x0000555555555154'.
	self assert: (frame at: #func) equals: 'main'.
	self assert: (frame at: #file) equals: 'testExample.cpp'.
	self assert: (frame at: #fullname) equals: './testExample.cpp'.
	self assert: (frame at: #line) equals: '5'.
	self assert: (frame at: #arch) equals: 'i386:x86-64'.

]

{ #category : #tests }
PhanideGDBOutputParserTest >> testParser [
	| records |
	records := self sample lines collect: [:line | PhanideGDBOutputParser parse: line].
	records do: [ :rec | self assert: rec isGDBOutputRecord ].
	self assert: records first isAsyncRecord. 
	self assert: records second isStreamRecord.
	self assert: (records at: 11) isEndRecord.
	self assert: (records at: 32) isAsyncRecord.
	self assert: (records at: 33) isResultRecord.
	self assert: records last isEndRecord.
]
