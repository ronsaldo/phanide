"
I represent an asynchronous output related to the running target.
"
Class {
	#name : #PhanideGDBExecAsyncOutput,
	#superclass : #PhanideGDBAsyncRecord,
	#category : 'Phanide-GDB-Output'
}

{ #category : #visiting }
PhanideGDBExecAsyncOutput >> accept: aVisitor [
	^ aVisitor visitExecAsyncOutput: self
]

{ #category : #'as yet unclassified' }
PhanideGDBExecAsyncOutput >> recordTypeName [
	^ #execAsyncOutput
]
