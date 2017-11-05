simplification
transitionStates: stateIndices withBase: baseIndex onEpsilonTo: targetState
	stateIndices do: [ :index | (states at: index + baseIndex) transitionOnEpsilonTo: targetState]