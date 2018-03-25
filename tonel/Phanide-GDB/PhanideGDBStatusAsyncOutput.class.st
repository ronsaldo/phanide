"
I represent an asynchronous status from gdb.
"
Class {
	#name : #PhanideGDBStatusAsyncOutput,
	#superclass : #PhanideGDBAsyncRecord,
	#category : 'Phanide-GDB-Output'
}

{ #category : #visiting }
PhanideGDBStatusAsyncOutput >> accept: aVisitor [
	^ aVisitor visitStatusAsyncOutput: self
]

{ #category : #'as yet unclassified' }
PhanideGDBStatusAsyncOutput >> recordTypeName [
	^ #statusAsyncOutput
]
