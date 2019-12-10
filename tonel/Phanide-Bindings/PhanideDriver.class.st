"
I represent a driver to the Phanide native API.

The Phanide native API provides facilities for the following features:
- Event driven API for handling subprocess.
- File system monitoring (inotify on Linux)

"
Class {
	#name : #PhanideDriver,
	#superclass : #Object,
	#instVars : [
		'context',
		'session',
		'eventFetchingProcess',
		'processDictionaryMutex',
		'processDictionary',
		'pendingEventsSemaphore',
		'pendingEventsSemaphoreIndex',
		'fsmonitorMutex',
		'fsmonitorDictionary'
	],
	#classVars : [
		'EventDispatchMap'
	],
	#pools : [
		'LibPhanidePool'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Phanide-Bindings-Driver'
}

{ #category : #initialization }
PhanideDriver class >> initialize [
	EventDispatchMap := Dictionary newFromPairs: {
		PHANIDE_EVENT_TYPE_PROCESS_PIPE_READY . #(processPipe onProcessPipeEvent:) .
		PHANIDE_EVENT_TYPE_PROCESS_FINISHED . #(processFinished onProcessFinishedEvent:) .
		PHANIDE_EVENT_TYPE_FSMONITOR . #(fsmonitor onFSMonitorEvent: ).
	}.

]

{ #category : #initialization }
PhanideDriver class >> isAvailable [
	^ LibPhanide isAvailable
]

{ #category : #accessing }
PhanideDriver class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ].
]

{ #category : #'session checking' }
PhanideDriver >> checkSession [
	session ~~ Smalltalk session ifTrue: [ 
		self initializeForNewSession
	]
]

{ #category : #events }
PhanideDriver >> createEventFetchingProcess [
	context canSignalExternalSemaphore ifTrue: [ 
		eventFetchingProcess := [
			self eventFetchingProcessEntry
		] forkAt: Processor lowIOPriority named: 'PhanideDriver event loop'.
	] ifFalse: [ 
		eventFetchingProcess := [
			self pollingEventFetchingProcessEntry
		] forkAt: Processor lowIOPriority named: 'PhanideDriver event loop'.
	]

]

{ #category : #events }
PhanideDriver >> eventFetchingIteration [
	| event |
	event := LibPhanideEvent new.
	[ context pollEvent: event ] whileTrue: [
		self processEvent: event
	]
]

{ #category : #events }
PhanideDriver >> eventFetchingProcessEntry [
	[
		[
			(session ~~ Smalltalk session or: [context isNil or: [context isNull]]) ifTrue: [ ^ self ].
			pendingEventsSemaphore consumeAllSignals.
			
			self eventFetchingIteration.
			
			pendingEventsSemaphore wait
		] repeat
	] ensure: [ Smalltalk unregisterExternalObject: pendingEventsSemaphore ]
]

{ #category : #events }
PhanideDriver >> getProcessFromHandle: aHandle [
	| process |
	processDictionaryMutex critical: [
		process := processDictionary at: aHandle ifAbsent: [ nil ].
	].
	^ process
]

{ #category : #initialization }
PhanideDriver >> initialize [
]

{ #category : #'session checking' }
PhanideDriver >> initializeForNewSession [
	eventFetchingProcess ifNotNil: [ eventFetchingProcess terminate ].
	pendingEventsSemaphore ifNotNil: [ 
		Smalltalk unregisterExternalObject: pendingEventsSemaphore
	].
	pendingEventsSemaphore := nil.
	
	self isAvailable ifFalse: [ ^ self ].

	pendingEventsSemaphore := Semaphore new.
	pendingEventsSemaphoreIndex := Smalltalk registerExternalObject: pendingEventsSemaphore.
	
	context := LibPhanideContext create: pendingEventsSemaphoreIndex.
	session := Smalltalk session.
	processDictionaryMutex := Semaphore forMutualExclusion.
	processDictionary := WeakValueDictionary new.

	fsmonitorMutex := Semaphore forMutualExclusion.
	fsmonitorDictionary := WeakValueDictionary new.
	self createEventFetchingProcess.
	
]

{ #category : #testing }
PhanideDriver >> isAvailable [
	^ LibPhanide isAvailable
]

{ #category : #'file system' }
PhanideDriver >> onFSMonitorEvent: event [
	| namePointer name handle eventHandle |
	namePointer := event name.
	name := nil.
	(namePointer isNotNil and: [ namePointer isNull not ]) ifTrue: [ 
		name := namePointer readStringUTF8.
		LibPhanide uniqueInstance free: namePointer
	].

	eventHandle := event handle.
	fsmonitorMutex critical: [
		handle := fsmonitorDictionary at: eventHandle getHandle ifAbsent: [ nil ].
		(event mask anyMask: PHANIDE_FSMONITOR_EVENT_DELETE_SELF) ifTrue: [ 
			(LibPhanideFSMonitor fromHandle: eventHandle) destroyOnContext: context.
			fsmonitorDictionary removeKey: eventHandle getHandle ifAbsent: []
		]
	].

	handle ifNotNil: [
		handle eventHandler ifNotNil: [ :handler |
			handler value: (PhanideFSMonitorWatchEvent new
				handle: handle;
				mask: event mask;
				cookie: event cookie;
				name: name;
				yourself)
		].
	].

]

{ #category : #events }
PhanideDriver >> onProcessFinishedEvent: event [
	| process |
	process := self getProcessFromHandle: event process getHandle.
	process ifNil: [ ^ self ].
	
	process finishedWithExitCode: event exitCode.
]

{ #category : #events }
PhanideDriver >> onProcessPipeEvent: event [
	| process |
	process := self getProcessFromHandle: event process getHandle.
	process ifNil: [ ^ self ].

	process signalPipe: event pipeIndex
]

{ #category : #events }
PhanideDriver >> pollingEventFetchingProcessEntry [
	[
		(session ~~ Smalltalk session or: [context isNil or: [context isNull]]) ifTrue: [ ^ self ].
		self eventFetchingIteration.
		
		(Delay forMilliseconds: 100) wait
	] repeat
]

{ #category : #events }
PhanideDriver >> processEvent: anEvent [
	| dispatchMethods |
	dispatchMethods := EventDispatchMap at: anEvent type ifAbsent: [ ^ self ].
	[
		self perform: dispatchMethods second with: (anEvent perform: dispatchMethods first)
	] on: Error do: [ :err |
		err freeze.
		[ err debug ] fork
	]
]

{ #category : #process }
PhanideDriver >> spawnShell: aCommand [
	^ self spawnShell: aCommand flags: PHANIDE_SPAWN_FLAGS_NONE
]

{ #category : #process }
PhanideDriver >> spawnShell: aCommand flags: flags [
	| handle process |
	self isAvailable ifFalse: [ ^ nil].
	
	self checkSession.
	processDictionaryMutex critical: [
		handle := context spawnShell: aCommand flags: flags.
		process := PhanideProcess newWithDriver: self handle: handle flags: flags.
		processDictionary at: handle getHandle getHandle put: process
	].

	^ process.
]

{ #category : #'file system' }
PhanideDriver >> watchDirectory: aPath eventHandler: eventHandler [
	| result handle |
	self isAvailable ifFalse: [ ^ nil].
	
	self checkSession.
	fsmonitorMutex critical: [
		handle := (context watchDirectory: aPath).
		(handle isNil or: [ handle isNull ]) ifTrue: [ ^ nil ].
		
		result := PhanideFSMonitorWatchHandle new
			eventHandler: eventHandler;
			handle: handle;
			yourself.
		fsmonitorDictionary at: handle getHandle getHandle put: result
	].

	^ result
	

]

{ #category : #'file system' }
PhanideDriver >> watchFile: aPath eventHandler: eventHandler [
	| result handle |
	self isAvailable ifFalse: [ ^ nil].
	
	self checkSession.
	fsmonitorMutex critical: [
		handle := (context watchFile: aPath).
		(handle isNil or: [ handle isNull ]) ifTrue: [ ^ nil ].
		
		result := PhanideFSMonitorWatchHandle new
			eventHandler: eventHandler;
			handle: handle;
			yourself.
		fsmonitorDictionary at: handle getHandle getHandle put: result
	].

	^ result
	

]
