accessing
start
	process := PhanideDriver uniqueInstance spawnShell: self gdbCommand.
	session := Smalltalk session.
	mutex := Semaphore forMutualExclusion.
	outputReadingProcess := self startOutputReadingProcess.
	stdin := process stdin textStream.
	self initializeGDBMI