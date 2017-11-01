accessing
cstring
	^ super cstring ==> [ :token |
		self parseCString: token second
	]
