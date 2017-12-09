initialization
initializeForNewSession
	registeredFilesMutex := Semaphore forMutualExclusion.
	registeredFiles := Dictionary new.
	session := Smalltalk session.