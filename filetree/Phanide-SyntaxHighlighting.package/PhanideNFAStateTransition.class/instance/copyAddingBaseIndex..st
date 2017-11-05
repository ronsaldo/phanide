copying
copyAddingBaseIndex: baseIndex
	^ self copy targets: (targets collect: [:t | t + baseIndex])