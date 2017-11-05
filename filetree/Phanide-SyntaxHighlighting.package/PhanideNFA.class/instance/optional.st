composition
optional
	| result baseIndex resultInitial resultAccepting |
	result := self class new.

	baseIndex := result addCopyingStatesWithBaseIndex: states.
	resultInitial := result newState.
	resultAccepting := result newState.
	
	resultInitial
		transitionOnEpsilonTo: initial + baseIndex;
		transitionOnEpsilonTo: resultAccepting index.
	accepting do: [ :a | (result states at: a + baseIndex) transitionOnEpsilonTo: resultAccepting index ].
	result initial: resultInitial index;
		accepting: { resultAccepting index }.
	^ result