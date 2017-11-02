*Phanide-Browser
makePhanideActiveAnchorIn: aPhanideBrowser
	owner widget ifNotNil: [:widget |
		widget widget ifNotNil: [ :morph |
			morph selectTabAt: (owner tabs indexOf: self)
		]
	]