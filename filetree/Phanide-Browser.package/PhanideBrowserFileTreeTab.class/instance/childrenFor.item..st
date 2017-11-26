initialization
childrenFor: fileReference item: item
	fileReferenceToNodeDictionary at: fileReference put: item.
	fileReference isDirectory ifFalse: [
		^ #()
	] ifTrue: [ 
		^ fileReference children sorted: [ :a :b |
			a isDirectory == b isDirectory ifTrue: [ 
				a basename <= b basename
			] ifFalse: [
				a isDirectory asBit >= b isDirectory asBit
			]
		]
	]