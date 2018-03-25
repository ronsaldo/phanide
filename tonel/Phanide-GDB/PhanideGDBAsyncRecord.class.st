"
I represent an asynchronous gdb notification.
"
Class {
	#name : #PhanideGDBAsyncRecord,
	#superclass : #PhanideGDBOutOfBandRecord,
	#instVars : [
		'token',
		'asyncClass',
		'results'
	],
	#category : 'Phanide-GDB-Output'
}

{ #category : #accessing }
PhanideGDBAsyncRecord >> asyncClass [
	^ asyncClass
]

{ #category : #accessing }
PhanideGDBAsyncRecord >> asyncClass: anObject [
	asyncClass := anObject
]

{ #category : #testing }
PhanideGDBAsyncRecord >> isAsyncRecord [
	^ true
]

{ #category : #printing }
PhanideGDBAsyncRecord >> printOn: aStream [
	aStream print: token; space; nextPutAll: self recordTypeName;
		space; print: asyncClass; space; print: results
]

{ #category : #accessing }
PhanideGDBAsyncRecord >> results [
	^ results
]

{ #category : #accessing }
PhanideGDBAsyncRecord >> results: anObject [
	results := anObject
]

{ #category : #accessing }
PhanideGDBAsyncRecord >> token [
	^ token
]

{ #category : #accessing }
PhanideGDBAsyncRecord >> token: anObject [
	token := anObject
]
