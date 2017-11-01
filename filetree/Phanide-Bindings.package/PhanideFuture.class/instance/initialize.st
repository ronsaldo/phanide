initialization
initialize
	super initialize.
	ready := false.
	mutex := Semaphore forMutualExclusion.
	readyCondition := PhanideConditionVariable new.