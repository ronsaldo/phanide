"
I am a GDB future command result. I am a future that holds a token.
"
Class {
	#name : #PhanideGDBFutureCommandResult,
	#superclass : #OSIOEventsFuture,
	#instVars : [
		'token'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #accessing }
PhanideGDBFutureCommandResult >> resultClass [
	^ self value resultClass
]

{ #category : #accessing }
PhanideGDBFutureCommandResult >> results [
	^ self value results
]

{ #category : #accessing }
PhanideGDBFutureCommandResult >> token [
	^ token
]

{ #category : #accessing }
PhanideGDBFutureCommandResult >> token: anObject [
	token := anObject
]
