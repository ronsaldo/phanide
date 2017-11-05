automata simulation
simulateStreamForPrefix: aStream
	| currentState c restorePosition bestResult bestAcceptingStateIndex |
	currentState := self initialSimulationState.
	restorePosition := aStream position.
	bestResult := nil.
	bestAcceptingStateIndex := nil.
	[aStream atEnd] whileFalse: [ 
		c := aStream peek.
		currentState := self computeFromSimulationState: currentState character: c.
		currentState ifNil: [
			aStream position: restorePosition.
			^ bestResult
		].
		aStream next.

		(currentState bestAcceptingState isNotNil and: [ bestAcceptingStateIndex isNil or: [currentState bestAcceptingState <= bestAcceptingStateIndex] ]) ifTrue: [
			bestResult := currentState.
			restorePosition := aStream position.
		].
	].
	aStream position: restorePosition.
	^ bestResult