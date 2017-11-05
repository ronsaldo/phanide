composition
, nextNFA
	| result firstBaseIndex secondBaseIndex |
	result := self class new.
	
	firstBaseIndex := result addCopyingStatesWithBaseIndex: states.
	secondBaseIndex := result addCopyingStatesWithBaseIndex: nextNFA states.

	result initial: initial + firstBaseIndex.
	result accepting: (nextNFA accepting collect: [ :ai | ai + secondBaseIndex]).
	result transitionStates: accepting withBase: firstBaseIndex onEpsilonTo: nextNFA initial + secondBaseIndex.
	^ result