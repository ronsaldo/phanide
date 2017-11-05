automata simulation
createSimulationStateForActiveStates: activeStates
	| result |
	activeStates isEmptyOrNil ifTrue: [ ^ nil ].
	result := PhanideNFASimulationState new.
	result activeStates: activeStates.
	result acceptingStates: (accepting select: [:s | activeStates includes: s]).
	^ result