initialization
initializeForProcess: aProcess index: aPipeIndex
	process := aProcess.
	index := aPipeIndex.
	mutex := Semaphore forMutualExclusion.
	readyCondition := PhanideCondition new.
	ready := true.