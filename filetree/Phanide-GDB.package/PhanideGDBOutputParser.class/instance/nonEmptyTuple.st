accessing
nonEmptyTuple
	^ super nonEmptyTuple ==> [ :tok |
		OrderedDictionary newFrom: {tok second} , (tok third collect: #second)
	]