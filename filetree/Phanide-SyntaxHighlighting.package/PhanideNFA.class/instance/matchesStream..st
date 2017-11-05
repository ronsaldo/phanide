automata simulation
matchesStream: aStream
	| finalState |
	finalState := self simulateStreamUntilEnd: aStream.
	^ finalState isNotNil and: [ finalState isAccepting ]