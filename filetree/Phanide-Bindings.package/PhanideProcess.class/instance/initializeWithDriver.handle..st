initialization
initializeWithDriver: aDriver handle: aHandle
	driver := aDriver.
	handle := aHandle.
	mutex := Semaphore forMutualExclusion.
	finishedCondition := PhanideCondition new.
	pipes := {
		"stdin" PhanideProcessWritePipe forProcess: self index: 0 .
		"stdout" PhanideProcessReadPipe forProcess: self index: 1 .
		"stderr" PhanideProcessReadPipe forProcess: self index: 2
	}