accessing
peek
	self remainingElementsInBuffer < 1 ifTrue: [ 
		self fillBuffer < 1 ifTrue: [ 
			^ nil
		]
	].
	
	^ buffer at: bufferPosition.