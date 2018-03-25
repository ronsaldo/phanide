"
I represent the result for a gdb command.
"
Class {
	#name : #PhanideGDBResultRecord,
	#superclass : #PhanideGDBOutputRecord,
	#instVars : [
		'token',
		'resultClass',
		'results'
	],
	#category : 'Phanide-GDB-Output'
}

{ #category : #visiting }
PhanideGDBResultRecord >> accept: aVisitor [
	^ aVisitor visitResultRecord: self
]

{ #category : #testing }
PhanideGDBResultRecord >> isResultRecord [
	^ true
]

{ #category : #printing }
PhanideGDBResultRecord >> printOn: aStream [
	aStream print: token; space; nextPutAll: self recordTypeName;
		space; print: resultClass; space; print: results
]

{ #category : #'as yet unclassified' }
PhanideGDBResultRecord >> recordTypeName [
	^ #result
]

{ #category : #accessing }
PhanideGDBResultRecord >> resultClass [
	^ resultClass
]

{ #category : #accessing }
PhanideGDBResultRecord >> resultClass: anObject [
	resultClass := anObject
]

{ #category : #accessing }
PhanideGDBResultRecord >> results [
	^ results
]

{ #category : #accessing }
PhanideGDBResultRecord >> results: anObject [
	results := anObject
]

{ #category : #accessing }
PhanideGDBResultRecord >> token [
	^ token
]

{ #category : #accessing }
PhanideGDBResultRecord >> token: anObject [
	token := anObject
]
