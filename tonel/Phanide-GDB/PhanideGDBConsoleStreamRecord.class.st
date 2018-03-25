"
I represent the console output from a gdb CLI command.
"
Class {
	#name : #PhanideGDBConsoleStreamRecord,
	#superclass : #PhanideGDBStreamRecord,
	#category : 'Phanide-GDB-Output'
}

{ #category : #visiting }
PhanideGDBConsoleStreamRecord >> accept: aVisitor [
	^ aVisitor visitConsoleStreamRecord: self
]

{ #category : #'as yet unclassified' }
PhanideGDBConsoleStreamRecord >> recordTypeName [
	^ #consoleStream
]
