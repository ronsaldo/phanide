visiting
visitResultRecord: record
	| tokenValue |
	record token ifNil: [ ^ self ].
	
	tokenValue := record token asInteger.
	pendingCommandsMutex critical: [
		pendingCommands at: tokenValue ifPresent: [ :result |
			pendingCommands removeKey: tokenValue.
			result value: record
		].
	].