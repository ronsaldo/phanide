Class {
	#name : #PhanideGDBBreakpoint,
	#superclass : #PhanideGDBHandle,
	#instVars : [
		'number',
		'type',
		'file',
		'line',
		'enabled',
		'func',
		'addr'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #'instance creation' }
PhanideGDBBreakpoint class >> for: gdb from: result [
	^ (self for: gdb) constructFromResult: result
]

{ #category : #accessing }
PhanideGDBBreakpoint >> addr [
	^ addr
]

{ #category : #accessing }
PhanideGDBBreakpoint >> addr: anObject [
	addr := anObject
]

{ #category : #'as yet unclassified' }
PhanideGDBBreakpoint >> constructFromResult: result [
	| bkpt |
	bkpt := result at: #bkpt.
	number := (bkpt at: #number) asInteger.
	type := (bkpt at: #type) asSymbol.
	enabled := (bkpt at: #enabled) ~= 'n'.
	file := bkpt at: #file.
	line := (bkpt at: #line) asInteger.
	func := bkpt at: #func ifAbsent: [nil].
	addr := bkpt at: #addr ifAbsent: [nil].

]

{ #category : #accessing }
PhanideGDBBreakpoint >> enabled [
	^ enabled
]

{ #category : #accessing }
PhanideGDBBreakpoint >> enabled: anObject [
	enabled := anObject
]

{ #category : #accessing }
PhanideGDBBreakpoint >> file [
	^ file
]

{ #category : #accessing }
PhanideGDBBreakpoint >> file: anObject [
	file := anObject
]

{ #category : #accessing }
PhanideGDBBreakpoint >> func [
	^ func
]

{ #category : #accessing }
PhanideGDBBreakpoint >> func: anObject [
	func := anObject
]

{ #category : #accessing }
PhanideGDBBreakpoint >> line [
	^ line
]

{ #category : #accessing }
PhanideGDBBreakpoint >> line: anObject [
	line := anObject
]

{ #category : #accessing }
PhanideGDBBreakpoint >> number [
	^ number
]

{ #category : #accessing }
PhanideGDBBreakpoint >> number: anObject [
	number := anObject
]

{ #category : #printing }
PhanideGDBBreakpoint >> printOn: aStream [
	aStream nextPutAll: 'Breakpoint '; print: number; space;
		nextPutAll: (enabled
			ifTrue: ['enabled']
			ifFalse: ['disabled'])
]

{ #category : #accessing }
PhanideGDBBreakpoint >> type [
	^ type
]

{ #category : #accessing }
PhanideGDBBreakpoint >> type: anObject [
	type := anObject
]
