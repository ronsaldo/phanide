compiling
noteCompilationOf: aSelector meta: isMeta
	isMeta ifTrue: [
		self class methodDict at: aSelector ifPresent: [:cm |
			(cm hasPragmaNamed: #styleTable:) ifTrue: [
				self reset
			]
		]
	]