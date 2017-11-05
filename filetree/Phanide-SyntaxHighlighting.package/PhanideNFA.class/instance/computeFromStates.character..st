automata simulation
computeFromStates: startStates character: aCharacter
	| newStates processedStates |
	newStates := Set new.
	processedStates := Set new.
	startStates do: [ :s |
		self computeFromState: s character: aCharacter processedStates: processedStates into: newStates.
	].

	^ newStates asArray sort