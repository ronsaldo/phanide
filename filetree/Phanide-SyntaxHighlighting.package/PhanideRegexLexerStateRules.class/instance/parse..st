parsing
parse: definition
	name := definition first.
	defaultStyle := definition second.
	rules := (definition allButFirst: 2) collect: [ :r | PhanideRegexLexerRule parse: r ].