as yet unclassified
applyStyle: styleName on: text from: start to: stop
	| style |
	style := styles at: styleName ifAbsent: [ ^ self ].
	style applyOn: text from: start to: stop