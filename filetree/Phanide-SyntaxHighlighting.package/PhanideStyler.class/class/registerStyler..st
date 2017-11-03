as yet unclassified
registerStyler: aStyler
	self stylerDictionary at: aStyler name put: aStyler.
	aStyler extensions do: [ :ext |
		self stylerExtensionDictionary at: ext put: aStyler
	]