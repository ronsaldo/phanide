events
getProcessFromHandle: aHandle
	| process |
	processDictionaryMutex critical: [
		process := processDictionary at: aHandle ifAbsent: [ nil ].
	].
	^ process