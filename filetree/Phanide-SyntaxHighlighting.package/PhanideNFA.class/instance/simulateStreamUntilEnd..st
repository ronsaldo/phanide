automata simulation
simulateStreamUntilEnd: aStream
	| currentState c |
	currentState := self simulationStateForActiveStates: {initial}.
	[aStream atEnd] whileFalse: [ 
		c := aStream next.
		currentState := self computeFromSimulationState: currentState character: c.
		currentState ifNil: [ ^ nil ].
	].
	^ currentState