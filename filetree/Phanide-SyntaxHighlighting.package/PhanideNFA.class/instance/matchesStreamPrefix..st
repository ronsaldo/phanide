automata simulation
matchesStreamPrefix: aStream
	| finalState |
	finalState := self simulateStreamForPrefix: aStream.
	^ finalState isNotNil and: [ finalState isAccepting ]