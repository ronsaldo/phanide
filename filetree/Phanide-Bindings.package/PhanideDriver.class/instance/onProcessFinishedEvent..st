events
onProcessFinishedEvent: event
	| process |
	process := self getProcessFromHandle: event process getHandle.
	process ifNil: [ ^ self ].
	
	process finishedWithExitCode: event exitCode.