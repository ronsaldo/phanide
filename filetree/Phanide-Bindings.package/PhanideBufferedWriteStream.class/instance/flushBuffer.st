flushing
flushBuffer
	| sizeToFlush |
	sizeToFlush := bufferPosition - 1.
	sizeToFlush = 0 ifTrue: [ ^ self ].
	stream write: sizeToFlush from: buffer offset: 1.
	bufferPosition := 1.