"
I represent the output from some gdb stream.
"
Class {
	#name : #PhanideGDBStreamRecord,
	#superclass : #PhanideGDBOutOfBandRecord,
	#instVars : [
		'value'
	],
	#category : 'Phanide-GDB-Output'
}

{ #category : #testing }
PhanideGDBStreamRecord >> isStreamRecord [
	^ true
]

{ #category : #printing }
PhanideGDBStreamRecord >> printOn: aStream [
	aStream nextPutAll: self recordTypeName; space; print: value.
]

{ #category : #accessing }
PhanideGDBStreamRecord >> value [
	^ value
]

{ #category : #accessing }
PhanideGDBStreamRecord >> value: anObject [
	value := anObject
]
