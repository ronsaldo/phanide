initialization
initialize
	mutex := Semaphore forMutualExclusion.
	waitingQueue := OrderedCollection new.
	