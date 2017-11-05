copying
copyAddingBaseIndex: baseIndex
	| result |
	result := self class new.
	result transitions: (transitions collect: [ :t | t copyAddingBaseIndex: baseIndex ]).
	^ result