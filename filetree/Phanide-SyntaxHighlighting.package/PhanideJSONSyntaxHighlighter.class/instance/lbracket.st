accessing
lbracket
	^ super lbracket ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle bracket token: token)
	]