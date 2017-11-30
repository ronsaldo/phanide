accessing
rcbracket
	^ super rcbracket ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle bracket token: token)
	]