as yet unclassified
applyOn: text from: start to: stop
	textAttributes do: [ :attr |
		text addAttribute: attr from: start to: stop
	].