automata simulation
computeFromState: stateIndex character: character processedStates: processedStates into: newStates
	| state |
	(processedStates includes: stateIndex) ifTrue: [ ^ self ].
	processedStates add: stateIndex.
	
	state := states at: stateIndex.
	state transitions do: [ :transition |
		"Follow the epsilon transitions."
		transition isEpsilon ifTrue: [
			transition targets do: [ :t |
				self computeFromState: t character: character processedStates: processedStates into: newStates
			]
		] ifFalse: [
			(transition acceptsCharacter: character) ifTrue: [
				transition targets do: [ :t | self addState: t withEpsilonsInto: newStates ]
			]
		]
	]