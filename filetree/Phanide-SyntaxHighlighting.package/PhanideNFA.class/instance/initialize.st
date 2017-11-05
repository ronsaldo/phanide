initialization
initialize
	super initialize.
	states := OrderedCollection new.
	simulationStateCacheMutex := Semaphore forMutualExclusion. 
	simulationStateCache := Dictionary new.