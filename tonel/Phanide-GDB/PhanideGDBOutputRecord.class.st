"
I represent an output record from GDB.

"
Class {
	#name : #PhanideGDBOutputRecord,
	#superclass : #Object,
	#category : 'Phanide-GDB-Output'
}

{ #category : #visiting }
PhanideGDBOutputRecord >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #testing }
PhanideGDBOutputRecord >> isAsyncRecord [
	^ false
]

{ #category : #testing }
PhanideGDBOutputRecord >> isEndRecord [
	^ false
]

{ #category : #testing }
PhanideGDBOutputRecord >> isGDBOutputRecord [
	^ true
]

{ #category : #testing }
PhanideGDBOutputRecord >> isOutOfBandRecord [
	^ false
]

{ #category : #testing }
PhanideGDBOutputRecord >> isResultRecord [
	^ false
]

{ #category : #testing }
PhanideGDBOutputRecord >> isStreamRecord [
	^ false
]

{ #category : #'as yet unclassified' }
PhanideGDBOutputRecord >> recordTypeName [
	^ self subclassResponsibility
]
