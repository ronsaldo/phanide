"
I represent a logging message by gdb that can be produced by the internals of gdb.
"
Class {
	#name : #PhanideGDBLogStreamRecord,
	#superclass : #PhanideGDBStreamRecord,
	#category : 'Phanide-GDB-Output'
}

{ #category : #visiting }
PhanideGDBLogStreamRecord >> accept: aVisitor [
	^ aVisitor visitLogStreamRecord: self
]

{ #category : #'as yet unclassified' }
PhanideGDBLogStreamRecord >> recordTypeName [
	^ #logStream
]
