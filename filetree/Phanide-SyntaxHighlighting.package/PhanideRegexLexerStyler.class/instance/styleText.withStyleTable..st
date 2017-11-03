as yet unclassified
styleText: aStringOrText withStyleTable: aStyleTable
	| text |
	text := aStringOrText asText.
	self styleText: text withBlock: [ :style :start :stop |
		aStyleTable applyStyle: style on: text from: start to: stop
	].

	^ text