commands
mi: aString withResult: aPhanideGDBFutureCommandResult
	stdin nextPutAll: aPhanideGDBFutureCommandResult token asString; nextPutAll: aString; lf.
	^ aPhanideGDBFutureCommandResult