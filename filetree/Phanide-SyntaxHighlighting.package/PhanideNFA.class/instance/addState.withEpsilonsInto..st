automata simulation
addState: targetState withEpsilonsInto: newStates
	(newStates includes: targetState) ifTrue: [ ^ self ].
	newStates add: targetState.
	
	(states at: targetState) transitions do: [ :transition |
		transition isEpsilon ifTrue: [
			transition targets do: [ :t | self addState: t withEpsilonsInto: newStates ]
		]
	]