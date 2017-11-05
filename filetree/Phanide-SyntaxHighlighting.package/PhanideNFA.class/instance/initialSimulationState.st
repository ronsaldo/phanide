automata simulation
initialSimulationState
	^ initialSimulationState ifNil: [initialSimulationState := self simulationStateForActiveStates: {initial} ]