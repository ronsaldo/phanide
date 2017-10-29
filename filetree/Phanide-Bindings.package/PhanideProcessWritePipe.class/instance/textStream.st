as yet unclassified
textStream
	^ (PhanideUTF8TextWriteStream on: self bufferedStream)
		flushOnNewLines: true;
		yourself