as yet unclassified
convertPipeError: aPipeResult
	aPipeResult < 0 ifTrue: [
		self error: 'Got an error from a pipe.'
	]