*Phanide-Browser
phanideDoubleClick: aBlock
	self whenBuiltDo: [ 
		self widget ifNotNil: [:widget |
			widget widget ifNotNil: [ :morph |
				morph on: #doubleClick send: #value to: aBlock
			]
		]
	]
