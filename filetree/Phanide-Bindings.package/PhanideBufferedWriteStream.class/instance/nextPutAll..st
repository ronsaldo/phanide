flushing
nextPutAll: aCollectionOfElements
	| remainingSize sourceIndex |
	aCollectionOfElements size <= bufferSize ifTrue: [ 
		remainingSize := aCollectionOfElements size.
		sourceIndex := 1.
		bufferPosition to: (bufferPosition + remainingSize - 1 min: bufferSize) do: [ :destIndex |
			buffer at: destIndex put: (aCollectionOfElements at: sourceIndex).
			sourceIndex := sourceIndex + 1.
			bufferPosition := bufferPosition + 1.
		].

		"Flush the buffer and put the remaining data on it."	
		remainingSize > 0 ifTrue: [ 
			self flushBuffer.
			1 to: remainingSize do: [ :destIndex |
				buffer at: destIndex put: (aCollectionOfElements at: sourceIndex).
				sourceIndex := sourceIndex + 1.
				bufferPosition := bufferPosition + 1.
			]
		]
		
	] ifFalse: [
		"Large transfer, write directly into the target stream."
		self flushBuffer.
		stream write: aCollectionOfElements size from: aCollectionOfElements offset: 1
	]