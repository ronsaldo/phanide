enumerating
leavesDo: aBlock
	value ifNotNil: [ ^ aBlock value: self ].
	left leavesDo: aBlock.
	right leavesDo: aBlock