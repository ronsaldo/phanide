accessing
string
	^ super string ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle string token: token).
		token
	]