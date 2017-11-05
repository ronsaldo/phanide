composition
/ alternativeNFA
	| result firstBaseIndex secondBaseIndex resultInitial resultAccepting |
	result := self class new.

	resultInitial := result newState.
	resultAccepting := result newState.
		
	firstBaseIndex := result addCopyingStatesWithBaseIndex: states.
	secondBaseIndex := result addCopyingStatesWithBaseIndex: alternativeNFA states.
	
	resultInitial
		transitionOnEpsilonTo: initial + firstBaseIndex;
		transitionOnEpsilonTo: alternativeNFA initial + secondBaseIndex.

	result initial: resultInitial index.
	result accepting: {resultAccepting index}.
	result transitionStates: (accepting collect: [ :i | i + firstBaseIndex]) onEpsilonTo: resultAccepting index.
	result transitionStates: (alternativeNFA accepting collect: [:i | i + secondBaseIndex]) onEpsilonTo: resultAccepting index.
	^ result