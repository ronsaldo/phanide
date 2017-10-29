accessing
nextPutAll: aCollection
	| newLineHaveBeenSeen |
	newLineHaveBeenSeen := false.
	aCollection do: [ :element |
		newLineHaveBeenSeen ifFalse: [ 
			newLineHaveBeenSeen := (String crlf includes: element)
		].
		
		self primitiveNextPut: element
	].
	
	(newLineHaveBeenSeen and: [flushOnNewLines]) ifTrue: [
		stream flush
	]