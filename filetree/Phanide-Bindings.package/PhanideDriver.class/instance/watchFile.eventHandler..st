file system
watchFile: aPath eventHandler: eventHandler
	| result handle |
	self isAvailable ifFalse: [ ^ nil].
	
	self checkSession.
	fsmonitorMutex critical: [
		handle := (context watchFile: aPath).
		(handle isNil or: [ handle isNull ]) ifTrue: [ ^ nil ].
		
		result := PhanideFSMonitorWatchHandle new
			eventHandler: eventHandler;
			handle: handle;
			yourself.
		fsmonitorDictionary at: handle getHandle getHandle put: result
	].

	^ result
	
