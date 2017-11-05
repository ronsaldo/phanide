adding
addCopyingStatesWithBaseIndex: aCollectionOfStates
	| baseIndex |
	baseIndex := states size.
	aCollectionOfStates do: [ :state | self addState: (state copyAddingBaseIndex: baseIndex) ].
	^ baseIndex