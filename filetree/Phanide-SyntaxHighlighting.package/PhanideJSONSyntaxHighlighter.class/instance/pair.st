accessing
pair
	^ super pair ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle keyword token: tokens first);
			add: (PhanideHighlightCommandStyle operator token: tokens second).
		tokens
	]