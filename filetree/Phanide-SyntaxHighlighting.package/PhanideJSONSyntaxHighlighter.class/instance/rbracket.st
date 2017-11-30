accessing
rbracket
	^ super rbracket ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle bracket token: token)
	]