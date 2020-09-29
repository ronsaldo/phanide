Class {
	#name : #PhideDebugSessionStackFrame,
	#superclass : #Object,
	#instVars : [
		'threadId',
		'level',
		'address',
		'function',
		'file',
		'line'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #accessing }
PhideDebugSessionStackFrame >> address [
	^ address
]

{ #category : #accessing }
PhideDebugSessionStackFrame >> address: anObject [
	address := anObject
]

{ #category : #accessing }
PhideDebugSessionStackFrame >> file [
	^ file
]

{ #category : #accessing }
PhideDebugSessionStackFrame >> file: anObject [
	file := anObject
]

{ #category : #accessing }
PhideDebugSessionStackFrame >> function [
	^ function
]

{ #category : #accessing }
PhideDebugSessionStackFrame >> function: anObject [
	function := anObject
]

{ #category : #accessing }
PhideDebugSessionStackFrame >> level [
	^ level
]

{ #category : #accessing }
PhideDebugSessionStackFrame >> level: anObject [
	level := anObject
]

{ #category : #accessing }
PhideDebugSessionStackFrame >> line [
	^ line
]

{ #category : #accessing }
PhideDebugSessionStackFrame >> line: anObject [
	line := anObject
]

{ #category : #printing }
PhideDebugSessionStackFrame >> printOn: aStream [
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
PhideDebugSessionStackFrame >> threadId [
	^ threadId
]

{ #category : #accessing }
PhideDebugSessionStackFrame >> threadId: anObject [
	threadId := anObject
]
