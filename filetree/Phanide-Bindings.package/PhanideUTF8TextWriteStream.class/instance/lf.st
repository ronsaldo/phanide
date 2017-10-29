writing
lf
	self nextPut: Character lf.
	flushOnNewLines ifTrue: [
		stream flush
	]