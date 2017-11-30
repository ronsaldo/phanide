accessing
lcbracket
	^ super lcbracket ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle bracket token: token)
	]