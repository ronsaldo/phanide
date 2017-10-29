accessing
next: size
	| result destIndex remainingToRead |
	result := buffer species new: size.
	destIndex := 1.
	remainingToRead := size.
	[remainingToRead > 0 ] whileTrue: [ 
		bufferPosition to: (bufferPosition + remainingToRead - 1 min: bufferSize) do: [ :sourceIndex |
			result at: destIndex put: (buffer at: sourceIndex).
			destIndex := destIndex + 1.
			remainingToRead := remainingToRead - 1.
			bufferPosition := bufferPosition + 1
		].
	
		remainingToRead > 0 ifTrue: [ 
			self fillBuffer < 1 ifTrue: [
				"EOF reached."
				^ result copyFrom: 1 to: destIndex - 1
			]
		].
	].

	^ result