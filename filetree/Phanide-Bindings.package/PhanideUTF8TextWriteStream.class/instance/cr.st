writing
cr
	self nextPut: Character cr.
	flushOnNewLines ifTrue: [
		stream flush
	]