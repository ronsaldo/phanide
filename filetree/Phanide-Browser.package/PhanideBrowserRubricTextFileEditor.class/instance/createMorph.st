initialization
createMorph
	textModel := RubScrolledTextModel new.
	^ textModel newScrolledText
		color: Smalltalk ui theme backgroundColor;
		textColor: Smalltalk ui theme textColor;
		textFont: StandardFonts codeFont;
		tabWidth: (StandardFonts codeFont characterFormAt: Character space) advance x * 4;
		yourself.
