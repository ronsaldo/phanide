"
I represent the end of a set of gdb output records. I represent the following string from the gdb machine interface:

(gdb)

"
Class {
	#name : #PhanideGDBEndRecord,
	#superclass : #PhanideGDBOutputRecord,
	#instVars : [
		'resultClass',
		'results'
	],
	#category : 'Phanide-GDB-Output'
}

{ #category : #visiting }
PhanideGDBEndRecord >> accept: aVisitor [
	^ aVisitor visitEndRecord: self
]

{ #category : #testing }
PhanideGDBEndRecord >> isEndRecord [
	^ true
]

{ #category : #printing }
PhanideGDBEndRecord >> printOn: aStream [
	aStream nextPutAll: self recordTypeName
]

{ #category : #'as yet unclassified' }
PhanideGDBEndRecord >> recordTypeName [
	^ #end
]
