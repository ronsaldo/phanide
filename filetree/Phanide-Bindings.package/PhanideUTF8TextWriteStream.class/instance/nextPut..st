accessing
nextPut: aCharacter
	self primitiveNextPut: aCharacter.
	(flushOnNewLines and: [String crlf includes: aCharacter]) ifTrue: [
		stream flush
	]
	