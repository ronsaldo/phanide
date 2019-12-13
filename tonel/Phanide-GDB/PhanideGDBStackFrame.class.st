Class {
	#name : #PhanideGDBStackFrame,
	#superclass : #PhanideGDBHandle,
	#instVars : [
		'addr',
		'func',
		'file',
		'line',
		'args',
		'arch',
		'level'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #accessing }
PhanideGDBStackFrame >> addr [
	^ addr
]

{ #category : #accessing }
PhanideGDBStackFrame >> addr: anObject [
	addr := anObject
]

{ #category : #accessing }
PhanideGDBStackFrame >> arch [
	^ arch
]

{ #category : #accessing }
PhanideGDBStackFrame >> arch: anObject [
	arch := anObject
]

{ #category : #accessing }
PhanideGDBStackFrame >> args [
	^ args
]

{ #category : #accessing }
PhanideGDBStackFrame >> args: anObject [
	args := anObject
]

{ #category : #'as yet unclassified' }
PhanideGDBStackFrame >> constructFromResult: data [
	level := (data at: #level ifAbsent: [ '0' ]) asInteger.
	addr := data at: #addr ifAbsent: [ nil ].
	func := data at: #func ifAbsent: [ nil ].
	file := data at: #file ifAbsent: [ nil ].
	line := (data at: #line ifAbsent: [ '0' ]) asInteger.
	args := data at: #args ifAbsent: [ nil ].
	arch := data at: #arch ifAbsent: [ nil ].
]

{ #category : #accessing }
PhanideGDBStackFrame >> file [
	^ file
]

{ #category : #accessing }
PhanideGDBStackFrame >> file: anObject [
	file := anObject
]

{ #category : #accessing }
PhanideGDBStackFrame >> func [
	^ func
]

{ #category : #accessing }
PhanideGDBStackFrame >> func: anObject [
	func := anObject
]

{ #category : #accessing }
PhanideGDBStackFrame >> level [
	^ level
]

{ #category : #accessing }
PhanideGDBStackFrame >> level: anObject [
	level := anObject
]

{ #category : #accessing }
PhanideGDBStackFrame >> line [
	^ line
]

{ #category : #accessing }
PhanideGDBStackFrame >> line: anObject [
	line := anObject
]
