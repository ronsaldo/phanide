automata simulation
computeFromSimulationState: startState character: aCharacter
	self flag: 'Check the performance cost of the mutex.'.
	"startState mutex critical: ["
		^ startState transitionAt: aCharacter ifAbsentPut: [
			self simulationStateForActiveStates: (self computeFromStates: startState activeStates character: aCharacter)
		]
	"]"