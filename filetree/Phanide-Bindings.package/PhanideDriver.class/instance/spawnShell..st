process
spawnShell: aCommand
	| handle process |
	self checkSession.
	processDictionaryMutex critical: [
		handle := context spawnShell: aCommand.
		process := PhanideProcess newWithDriver: self handle: handle.
		processDictionary at: handle getHandle getHandle put: process
	].

	^ process.