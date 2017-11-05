simplification
simplified
	| preservedStateCount stateRenameDictionary pendingNodes result newInitial |
	preservedStateCount := 0.
	stateRenameDictionary := Dictionary new.
	pendingNodes := Set new.
	states do: [ :state |
		state isOnlyEpsilon ifTrue: [ 
			stateRenameDictionary at: state index put: (state transitions collect: #targets) flattened.
			pendingNodes add: state index
		] ifFalse: [
			preservedStateCount := preservedStateCount + 1.
			stateRenameDictionary at: state index put: { preservedStateCount }.
		]
	].

	self processStateRenameDictionary: stateRenameDictionary pendingNodes: pendingNodes.
	result := self class new.
	states do: [ :state |
		state isOnlyEpsilon ifFalse: [
			result addState: (state copyWithRenameDictionary: stateRenameDictionary)
		]
	].
	result initial: (stateRenameDictionary at: initial).
	result initial size = 1 ifTrue: [
		result initial: result initial first.
	] ifFalse: [ 
		newInitial := result newState.
		newInitial transitionOnEpsilonToAll: result initial.
		result initial: newInitial index.
	].

	result accepting: (Array streamContents: [:out |
		accepting do: [ :as |
			out nextPutAll: (stateRenameDictionary at: as) 
		]
	]).
	^ result