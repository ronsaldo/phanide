accessing
result
	^ super result ==> [ :tok |
		tok first -> tok third
	]