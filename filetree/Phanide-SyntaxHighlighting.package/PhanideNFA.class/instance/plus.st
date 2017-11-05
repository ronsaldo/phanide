composition
plus
	| result baseIndex resultAccepting resultContinue |
	result := self class new.

	baseIndex := result addCopyingStatesWithBaseIndex: states.
	resultContinue := result newState.
	resultAccepting := result newState.
	
	resultContinue
		transitionOnEpsilonTo: initial + baseIndex;
		transitionOnEpsilonTo: resultAccepting index.
	accepting do: [ :a | (result states at: a + baseIndex) transitionOnEpsilonTo: resultContinue index ].
	result initial: initial + baseIndex;
		accepting: { resultAccepting index }.
	^ result