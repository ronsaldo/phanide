as yet unclassified
attributesForStyle: styleName
	^ styles at: styleName ifPresent: [:style | style attributes ] ifAbsent: [ #() ].