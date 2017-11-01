accessing
results
	^ super results ==> [ :tok |
		OrderedDictionary newFrom: (tok collect: #second)
	]