Class {
	#name : #PhanideGDBEvent,
	#superclass : #Object,
	#instVars : [
		'gdb'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #'instance creation' }
PhanideGDBEvent class >> for: gdb [
	^ self new gdb: gdb
]

{ #category : #'instance creation' }
PhanideGDBEvent class >> for: gdb with: eventData [
	^ (self for: gdb)
		parseEventData: eventData
]

{ #category : #accessing }
PhanideGDBEvent >> gdb [
	^ gdb
]

{ #category : #accessing }
PhanideGDBEvent >> gdb: anObject [
	gdb := anObject
]

{ #category : #parsing }
PhanideGDBEvent >> parseEventData: eventData [
]

{ #category : #visiting }
PhanideGDBEvent >> processWith: eventHandler [
	self subclassResponsibility
]
