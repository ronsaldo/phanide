"
I am a watched element by the file system monitor.
"
Class {
	#name : #PhanideFileSystemMonitorWatchedElement,
	#superclass : #Object,
	#instVars : [
		'handle',
		'fileReference',
		'pendingUnprocessedEvents',
		'nextEventCoalescingTime',
		'dispatcher',
		'isDirectory',
		'needsExplicitChildPoll',
		'childrenState',
		'parentWatcher',
		'childrenWatchers',
		'childrenStateMutex',
		'supportedEventMask'
	],
	#pools : [
		'LibPhanidePool'
	],
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #'instance creation' }
PhanideFileSystemMonitorWatchedElement class >> for: aFileReference [
	^ self basicNew initializeFor: aFileReference
]

{ #category : #private }
PhanideFileSystemMonitorWatchedElement >> checkChildrenWatcherExistenceIfNeeded [
	needsExplicitChildPoll ifFalse: [ ^ self ].
	childrenStateMutex critical: [
		self needsChildrenWatchers ifTrue: [
			childrenWatchers ifEmpty: [ 
				childrenState keys asArray do: [ :key | self ensureChildWatcherFor: key ]
			]
		] ifFalse: [
			childrenWatchers keys asArray do: [ :key | self removeChildWatcherFor: key ].
		]
	]
]

{ #category : #private }
PhanideFileSystemMonitorWatchedElement >> checkDestroyCondition [
	(parentWatcher isNil and: [dispatcher hasSubscriptions not]) ifTrue: [
		self destroy
	].
]

{ #category : #'events-processing' }
PhanideFileSystemMonitorWatchedElement >> coalesceAndDispatchEvents [
	| coalescedElementDictionary coalescedEvents pendingUnprocessedEvent lastCoalescedEvent coalescedEvent |
	coalescedElementDictionary := Dictionary new.
	coalescedEvents := OrderedCollection new.
	lastCoalescedEvent := nil.
	[pendingUnprocessedEvent := pendingUnprocessedEvents nextOrNil] whileNotNil: [
		coalescedEvent := coalescedElementDictionary at: pendingUnprocessedEvent name ifAbsentPut: [
			| syntheticEvent |
			syntheticEvent := pendingUnprocessedEvent copy.
			coalescedEvents add: syntheticEvent.
			syntheticEvent
		].
		coalescedEvent mask: (coalescedEvent mask bitOr: pendingUnprocessedEvent mask).
		
		lastCoalescedEvent ifNotNil: [ 
			((coalescedEvent mask anyMask: PHANIDE_FSMONITOR_EVENT_MOVED_FROM) and:
			[ lastCoalescedEvent mask anyMask: PHANIDE_FSMONITOR_EVENT_MOVED_TO]) ifTrue: [
				coalescedEvents add: (PhanideFileEventMoved new
					fileReference: coalescedEvent fileReference;
					newFileReference: lastCoalescedEvent fileReference;
					yourself)
			]. 
			((coalescedEvent mask anyMask: PHANIDE_FSMONITOR_EVENT_MOVED_TO) and:
			[ lastCoalescedEvent mask anyMask: PHANIDE_FSMONITOR_EVENT_MOVED_FROM]) ifTrue: [
				coalescedEvents add: (PhanideFileEventMoved new
					fileReference: lastCoalescedEvent fileReference;
					newFileReference: coalescedEvent fileReference;
					yourself)
			]. 
		].
		
		lastCoalescedEvent := coalescedEvent
	].

	coalescedEvents do: [ :each |
		each deliverWithWatcher: self
	].

]

{ #category : #'events-processing' }
PhanideFileSystemMonitorWatchedElement >> deliverProcessedEvent: processedEvent [
	| isForMyself |
	isForMyself := processedEvent fileReference = fileReference.
	processedEvent isModify ifTrue: [
		(needsExplicitChildPoll and: [ isForMyself ]) ifTrue: [ 
			self pollNewChildrenStateAndDeliverEvents
		].
	].

	dispatcher deliverEvent: processedEvent.
	isForMyself ifTrue: [
		parentWatcher ifNotNil: [ :p | parentWatcher deliverProcessedEvent: processedEvent ]
	] ifFalse: [
		dispatcher deliverChild: fileReference basename event: processedEvent		
	].

	"Synthesize additional events, in case there are not supported by the underlying platform."
	processedEvent isModify ifTrue: [ 
		(isDirectory not and: [ (supportedEventMask anyMask: PHANIDE_FSMONITOR_EVENT_CLOSE_WRITE) not ]) ifFalse: [
			self deliverProcessedEvent: processedEvent asCloseWriteEvent
		]
	].

]

{ #category : #initialization }
PhanideFileSystemMonitorWatchedElement >> destroy [
	PhanideFileSystemMonitor uniqueInstance destroyWatcher: self.
	handle := nil.
]

{ #category : #'events-processing' }
PhanideFileSystemMonitorWatchedElement >> doPollNewChildrenStateAndDeliverEvents [
	| newChildrenState needsChildrenWatchers |
	newChildrenState := self fetchCurrentChildrenState.
	needsChildrenWatchers := self needsChildrenWatchers.
	
	childrenState keysAndValuesDo: [ :key :oldState |
		newChildrenState at: key ifAbsent: [
			self deliverProcessedEvent: (PhanideFileEventDelete new
				fileReference: oldState fileReference).
			needsChildrenWatchers ifTrue: [
				self removeChildWatcherFor: key
			]
		]
	].

	newChildrenState keysAndValuesDo: [ :key :newState |
		needsChildrenWatchers ifTrue: [
			self ensureChildWatcherFor: key
		].

		childrenState at: key ifPresent: [ :oldState |
			oldState size ~= newState size ifTrue: [ 
				self deliverProcessedEvent: (PhanideFileEventModify new
					fileReference: oldState fileReference)
			].
		] ifAbsent: [ 
			self 
				deliverProcessedEvent: (PhanideFileEventCreate new
					fileReference: newState fileReference);
				deliverProcessedEvent: (PhanideFileEventCloseWrite new
					fileReference: newState fileReference)
		]
	].

	childrenState := newChildrenState
]

{ #category : #'events-processing' }
PhanideFileSystemMonitorWatchedElement >> enqueueEventProcessing: rawEvent [
	| eventWithTimesTamp elementFileReference mask |
	elementFileReference := rawEvent name ifNil: [ fileReference ] ifNotNil: [ fileReference / rawEvent name ].
	mask := rawEvent mask.
	eventWithTimesTamp := PhanideFileSystemMonitorUnprocessedEvent new
		mask: mask;
		fileReference: elementFileReference;
		name: rawEvent name;
		timeStamp: Time microsecondClockValue;
		yourself.
	pendingUnprocessedEvents nextPut: eventWithTimesTamp.
	PhanideDriver uniqueInstance queueWatcherForEventCoalescing: self in: 200000
]

{ #category : #'events-processing' }
PhanideFileSystemMonitorWatchedElement >> ensureChildWatcherFor: childName [
	childrenWatchers at: childName ifAbsentPut: [
		| watcher |
		watcher := PhanideFileSystemMonitor uniqueInstance for: childName.
		self assert: watcher parentWatcher isNil.
		watcher parentWatcher: self.
		watcher
	]

]

{ #category : #'events-processing' }
PhanideFileSystemMonitorWatchedElement >> fetchCurrentChildrenState [
	| newChildrenState |
	newChildrenState := Dictionary new.
	
	fileReference children do: [ :child |
		| newState |
		newState := PhanideFileSystemMonitorFileState for: child.
		newChildrenState at: newState name put: newState
	].
	^ newChildrenState
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> handle [
	^ handle
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> handle: anObject [
	handle := anObject
]

{ #category : #initialization }
PhanideFileSystemMonitorWatchedElement >> initializeFor: aFileReference [
	fileReference := aFileReference.
	pendingUnprocessedEvents := WaitfreeQueue new.
	dispatcher := PhanideEventDispatcher new owner: self.
	isDirectory := aFileReference isDirectory.
	needsExplicitChildPoll := isDirectory and: [ PhanideDriver uniqueInstance fsMonitorCanWatchDirectoryFileModifications not ].
	childrenWatchers := Dictionary new.
	childrenStateMutex := Semaphore forMutualExclusion.
	
	isDirectory ifTrue: [
		needsExplicitChildPoll ifTrue: [ childrenState := self fetchCurrentChildrenState ].
		handle := PhanideDriver uniqueInstance watchDirectory: aFileReference fullName eventHandler:
			[ :event | self enqueueEventProcessing: event ]
	] ifFalse: [
		handle := PhanideDriver uniqueInstance watchFile: aFileReference fullName eventHandler:
			[ :event | self enqueueEventProcessing: event ]
	].
	supportedEventMask := handle supportedEventMask.

]

{ #category : #testing }
PhanideFileSystemMonitorWatchedElement >> needsChildrenWatchers [
	^ needsExplicitChildPoll and: [ dispatcher hasAnySubscriptionForEventClasses: { 
		PhanideFileEventCloseWrite
	} ]
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> nextEventCoalescingTime [
	^ nextEventCoalescingTime
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> nextEventCoalescingTime: anObject [
	nextEventCoalescingTime := anObject
]

{ #category : #'event subscriptions' }
PhanideFileSystemMonitorWatchedElement >> onChild: basename subscribeEvent: anEvent withAction: aBlock [
	| subscription |
	subscription := dispatcher onChild: basename subscribeEvent: anEvent withAction: aBlock.
	self checkChildrenWatcherExistenceIfNeeded.
	^ subscription
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> parentWatcher [
	^ parentWatcher
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> parentWatcher: anObject [
	parentWatcher := anObject.
	parentWatcher ifNil: [ self checkDestroyCondition ].
]

{ #category : #'events-processing' }
PhanideFileSystemMonitorWatchedElement >> pollNewChildrenStateAndDeliverEvents [
	childrenStateMutex critical: [ 
		self doPollNewChildrenStateAndDeliverEvents
	]
]

{ #category : #'events-processing' }
PhanideFileSystemMonitorWatchedElement >> removeChildWatcherFor: childName [
	childrenWatchers at: childName ifPresent: [ :existent |
		existent parentWatcher: nil.
		childrenWatchers removeKey: childName
	]
]

{ #category : #'event subscriptions' }
PhanideFileSystemMonitorWatchedElement >> subscribeEvent: anEvent withAction: aBlock [
	| subscription |
	subscription := dispatcher subscribeEvent: anEvent withAction: aBlock.
	self checkChildrenWatcherExistenceIfNeeded.
	^ subscription
]

{ #category : #private }
PhanideFileSystemMonitorWatchedElement >> subscriptionRemoved [
	self checkChildrenWatcherExistenceIfNeeded.
	self checkDestroyCondition.
]
