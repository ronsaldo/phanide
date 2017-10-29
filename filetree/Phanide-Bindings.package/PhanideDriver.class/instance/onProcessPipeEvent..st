events
onProcessPipeEvent: event
	| process |
	process := self getProcessFromHandle: event process getHandle.
	process ifNil: [ ^ self ].

	process signalPipe: event pipeIndex