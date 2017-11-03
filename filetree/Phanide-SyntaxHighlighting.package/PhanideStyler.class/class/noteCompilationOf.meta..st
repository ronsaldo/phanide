compiling
noteCompilationOf: aSelector meta: isMeta
	isMeta ifTrue: [
		self class methodDict at: aSelector ifPresent: [:cm |
			(cm hasPragmaNamed: #styler) ifTrue: [
				self perform: aSelector
			]
		]
	]