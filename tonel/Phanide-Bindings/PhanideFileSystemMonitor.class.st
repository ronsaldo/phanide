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

{ #category : #'as yet unclassified' }
PhanideFileSystemMonitor >> destroyWatcher: watcher [
	PhanideDriver isAvailable ifFalse: [ ^ nil ].

	registeredFilesMutex critical: [
		registeredFiles at: watcher fileReference ifPresent: [ :registeredWatcher |
			registeredWatcher == watcher ifTrue: [
				registeredFiles removeKey: watcher fileReference
			]
		]
	].

	PhanideDriver uniqueInstance destroyFSMonitor: watcher handle
]

{ #category : #'event subscriptions' }
PhanideFileSystemMonitor >> for: aPath [
	| watchedFileReference watchedElement |
	PhanideDriver isAvailable ifFalse: [ ^ nil ].
	
	watchedFileReference := aPath asFileReference asAbsolute.
	self checkSession.
	watchedFileReference exists ifFalse: [ ^ nil ].
	
	registeredFilesMutex critical: [
		watchedElement := registeredFiles at: watchedFileReference
			ifAbsentPut: [ PhanideFileSystemMonitorWatchedElement for: watchedFileReference ]
	].

	^ watchedElement
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
PhanideFileSystemMonitor >> on: aPath element: basename when: anEvent do: aBlock [
	^ (self for: aPath)
		ifNil: [ PhanideNullEventSubscription uniqueInstance ]
		ifNotNil: [ :watcher | watcher onChild: basename subscribeEvent: anEvent withAction: aBlock]
]

{ #category : #'event subscriptions' }
PhanideFileSystemMonitor >> on: aPath when: anEvent do: aBlock [
	| watchedFileReference parent |
	PhanideDriver isAvailable ifFalse: [ ^ PhanideNullEventSubscription uniqueInstance ].
	
	watchedFileReference := aPath asFileReference asAbsolute.
	(watchedFileReference isFile and: [anEvent isPreferredInParentFolder or:
		[ PhanideDriver uniqueInstance fsMonitorCanWatchFiles not]]) ifTrue: [
		parent := watchedFileReference parent.
		^ self on: parent element: watchedFileReference basename when: anEvent do: aBlock
	].
	
	^ (self for: aPath)
		ifNil: [ PhanideNullEventSubscription uniqueInstance ]
		ifNotNil: [ :watcher | watcher subscribeEvent: anEvent withAction: aBlock]
]
