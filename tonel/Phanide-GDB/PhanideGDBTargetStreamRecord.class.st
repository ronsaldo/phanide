"
I contain textual output from the running target.
"
Class {
	#name : #PhanideGDBTargetStreamRecord,
	#superclass : #PhanideGDBStreamRecord,
	#category : 'Phanide-GDB-Output'
}

{ #category : #visiting }
PhanideGDBTargetStreamRecord >> accept: aVisitor [
	^ aVisitor visitTargetStreamRecord: self
]

{ #category : #'as yet unclassified' }
PhanideGDBTargetStreamRecord >> recordTypeName [
	^ #targetStream
]
