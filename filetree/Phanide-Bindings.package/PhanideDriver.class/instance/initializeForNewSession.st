session checking
initializeForNewSession
	eventFetchingProcess ifNotNil: [ eventFetchingProcess terminate ].
	context := LibPhanideContext create.
	session := Smalltalk session.
	processDictionaryMutex := Semaphore forMutualExclusion.
	processDictionary := WeakValueDictionary new.
	self createEventFetchingProcess.
	