initialization
createMorph
	textModel := RubScrolledTextModel new.
	^ textModel newScrolledText
		color: Smalltalk ui theme backgroundColor;
		textColor: Smalltalk ui theme textColor;
		textFont: StandardFonts codeFont;
		yourself.
