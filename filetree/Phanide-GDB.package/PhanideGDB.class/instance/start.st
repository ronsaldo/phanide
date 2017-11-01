accessing
start
	process := PhanideDriver uniqueInstance spawnShell: self gdbCommand.
	session := Smalltalk session.
	
	mutex := Semaphore forMutualExclusion.
	pendingCommands := Dictionary new.
	pendingCommandsMutex := Semaphore forMutualExclusion.

	outputReadingProcess := self startOutputReadingProcess.
	
	stdin := process stdin textStream.
	self initializeGDBMI