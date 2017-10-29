waiting
wait
	mutex critical: [
		[exitCode] whileNil: [ 
			finishedCondition wait: mutex
		].
	
		^ exitCode
	]