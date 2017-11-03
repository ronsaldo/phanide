parsing
parseStyleDefinition: styleDefinition
	| style color parsedAttributes emphasis |
	style := PhanideSyntaxStyle new.
	style name: styleDefinition first.
	styles at: style name put: style.
	
	color := Color colorFrom: styleDefinition second. 
	parsedAttributes := {TextColor color: color}.
	styleDefinition size >= 3 ifTrue: [
		emphasis := styleDefinition third.
		parsedAttributes := parsedAttributes , { TextEmphasis perform: emphasis }
	].

	style textAttributes: parsedAttributes.