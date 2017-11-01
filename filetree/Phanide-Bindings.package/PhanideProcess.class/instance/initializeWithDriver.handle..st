initialization
initializeWithDriver: aDriver handle: aHandle
	driver := aDriver.
	handle := aHandle.
	mutex := Semaphore forMutualExclusion.
	finishedCondition := PhanideConditionVariable new.
	pipes := {
		"stdin" PhanideProcessWritePipe forProcess: self index: 0 .
		"stdout" PhanideProcessReadPipe forProcess: self index: 1 .
		"stderr" PhanideProcessReadPipe forProcess: self index: 2
	}