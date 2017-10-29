accessing
fillBuffer
	bufferSize := stream readInto: buffer startingAt: 1 count: buffer size.
	bufferPosition := 1.
	^ bufferSize