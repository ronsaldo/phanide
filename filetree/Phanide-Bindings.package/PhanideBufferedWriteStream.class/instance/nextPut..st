flushing
nextPut: anElement
	self remainingCapacity < 1 ifTrue: [
		self flushBuffer.
	].

	buffer at: bufferPosition put: anElement.
	bufferPosition := bufferPosition + 1