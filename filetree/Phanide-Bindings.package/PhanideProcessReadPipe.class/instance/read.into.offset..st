accessing
read: n into: aBuffer offset: aBufferOffset
	| resultCount |
	mutex critical: [
		[
			"Wait for the pipe to be ready"
			[ready] whileFalse: [ readyCondition wait: mutex ].
			resultCount := process handle pipe: index readInto: aBuffer offset: aBufferOffset - 1 count: n.
			resultCount = PHANIDE_PIPE_ERROR_WOULD_BLOCK ifTrue: [ 
				ready := false.
			].
		] doWhileTrue: [ ready not ]
	].

	"Treat a read from a closed pipe as a read of size 1."
	resultCount = PHANIDE_PIPE_ERROR_CLOSED ifTrue: [ 
		resultCount := 0.
	].

	self convertPipeError: resultCount.
	^ resultCount