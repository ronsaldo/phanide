as yet unclassified
textAttributesForStyle: styleName
	^ styles at: styleName ifPresent: [:style | style textAttributes ] ifAbsent: [ #() ].