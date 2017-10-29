writing
crlf
	self nextPutAll: String crlf.
	flushOnNewLines ifTrue: [
		stream flush
	]