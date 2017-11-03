parsing
parse: aStyleTableDefinition
	styles := Dictionary new.
	aStyleTableDefinition do: [ :styleDefinition | self parseStyleDefinition: styleDefinition ]