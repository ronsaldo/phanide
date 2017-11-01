initialization
initializeForProcess: aProcess index: aPipeIndex
	process := aProcess.
	index := aPipeIndex.
	mutex := Semaphore forMutualExclusion.
	readyCondition := PhanideConditionVariable new.
	ready := true.