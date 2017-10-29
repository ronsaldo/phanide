accessing
stream: anObject
	stream := anObject.
	buffer := stream isBinary ifTrue: [ ByteArray new: BufferSize ] ifFalse: [ ByteString new: BufferSize ].
	bufferPosition := 1.
	bufferSize := BufferSize.