Class {
	#name : #PhanideGDBHandle,
	#superclass : #Object,
	#instVars : [
		'gdb'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #'instance creation' }
PhanideGDBHandle class >> for: gdb [
	^ self new gdb: gdb
]

{ #category : #'instance creation' }
PhanideGDBHandle class >> for: gdb from: result [
	^ (self for: gdb) constructFromResult: result
]

{ #category : #'as yet unclassified' }
PhanideGDBHandle >> constructFromResult: result [

]

{ #category : #accessing }
PhanideGDBHandle >> gdb [
	^ gdb
]

{ #category : #accessing }
PhanideGDBHandle >> gdb: anObject [
	gdb := anObject
]
