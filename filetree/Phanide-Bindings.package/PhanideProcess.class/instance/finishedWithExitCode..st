events
finishedWithExitCode: anExitCode
	mutex critical: [ 
		exitCode := anExitCode.
		finishedCondition signal
	]
	
	