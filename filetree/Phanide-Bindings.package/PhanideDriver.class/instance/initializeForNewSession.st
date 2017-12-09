session checking
initializeForNewSession
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
	