Class {
	#name : #PhanideBrowserDebuggerStackTraceFrame,
	#superclass : #Object,
	#instVars : [
		'threadId',
		'level',
		'address',
		'function',
		'file',
		'line'
	],
	#category : #'Phanide-Browser-Debugging'
}

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> address [
	^ address
]

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> address: anObject [
	address := anObject
]

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> file [
	^ file
]

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> file: anObject [
	file := anObject
]

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> function [
	^ function
]

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> function: anObject [
	function := anObject
]

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> level [
	^ level
]

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> level: anObject [
	level := anObject
]

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> line [
	^ line
]

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> line: anObject [
	line := anObject
]

{ #category : #printing }
PhanideBrowserDebuggerStackTraceFrame >> printOn: aStream [
	aStream print: level.
	address ifNotNil: [ aStream nextPutAll: ' Address: '; print: address ].
	function ifNotNil: [
		aStream nextPutAll: ' Function: '; nextPutAll: function.
	].
	file ifNotNil: [
		aStream nextPutAll: ' File: '; print: file.
		line ifNotNil: [ aStream nextPutAll: ' Line: '; print: line ]
	].
]

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> threadId [
	^ threadId
]

{ #category : #accessing }
PhanideBrowserDebuggerStackTraceFrame >> threadId: anObject [
	threadId := anObject
]
