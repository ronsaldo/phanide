accessing
characterClass
	^ super characterClass ==> [ :list |
		| elements result |
		elements := list third.
		result := elements first copy.
		elements allButFirstDo: [ :el | result := result union: el ].
		list second ifNotNil: [ result negated asNFA] ifNil: [ result asNFA]
	]