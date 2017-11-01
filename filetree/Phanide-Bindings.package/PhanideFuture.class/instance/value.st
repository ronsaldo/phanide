accessing
value
	mutex critical: [ 
		[ ready ] whileFalse: [
			readyCondition wait: mutex
		].
	
		^ value
	]