"
I am a monitor for the file system.

I provide capabilites on monitoring a directory or a file for changes.

"
Class {
	#name : #PhanideFileSystemMonitor,
	#superclass : #Object,
	#instVars : [
		'session',
		'registeredFilesMutex',
		'registeredFiles'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Phanide-Bindings-FileSystem'
}

{ #category : #'event subscriptions' }
PhanideFileSystemMonitor class >> on: aPath when: anEvent do: aBlock [
	^ self uniqueInstance on: aPath when: anEvent do: aBlock
]

{ #category : #accessing }
PhanideFileSystemMonitor class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ].
]

{ #category : #'session management' }
PhanideFileSystemMonitor >> checkSession [
	session ~~ Smalltalk session ifTrue: [
		self initializeForNewSession
	]
]

{ #category : #initialization }
PhanideFileSystemMonitor >> initialize [
	super initialize.
	
]

{ #category : #initialization }
PhanideFileSystemMonitor >> initializeForNewSession [
	registeredFilesMutex := Semaphore forMutualExclusion.
	registeredFiles := Dictionary new.
	session := Smalltalk session.
]

{ #category : #'event subscriptions' }
PhanideFileSystemMonitor >> on: aPath when: anEvent do: aBlock [
	| watchedFileReference watchedElement |
	PhanideDriver isAvailable ifFalse: [ ^ self ].
	
	self checkSession.
	watchedFileReference := aPath asFileReference asAbsolute.
	watchedFileReference exists ifFalse: [ ^ self ].
	
	registeredFilesMutex critical: [
		watchedElement := registeredFiles at: watchedFileReference
			ifAbsentPut: [ PhanideFileSystemMonitorWatchedElement for: watchedFileReference ]
	].

	watchedElement announcer when: anEvent do: aBlock
]
