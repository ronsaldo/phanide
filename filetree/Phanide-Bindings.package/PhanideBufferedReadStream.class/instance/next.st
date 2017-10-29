accessing
next
	| result |
	self remainingElementsInBuffer < 1 ifTrue: [ 
		self fillBuffer < 1 ifTrue: [ 
			^ nil
		]
	].
	
	result := buffer at: bufferPosition.
	bufferPosition := bufferPosition + 1.
	^ result