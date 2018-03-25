"
I represent an asynchronous notification from gdb.
"
Class {
	#name : #PhanideGDBNotifyAsyncOutput,
	#superclass : #PhanideGDBAsyncRecord,
	#category : 'Phanide-GDB-Output'
}

{ #category : #visiting }
PhanideGDBNotifyAsyncOutput >> accept: aVisitor [
	^ aVisitor visitNotifyAsyncOutput: self
]

{ #category : #'as yet unclassified' }
PhanideGDBNotifyAsyncOutput >> recordTypeName [
	^ #notifyAsyncOutput
]
