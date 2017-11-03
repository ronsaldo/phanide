as yet unclassified
styler: stylerName extensions: extensions regex: regexDefinition
	self registerStyler: (PhanideRegexStyler new
		name: stylerName;
		extensions: extensions;
		lexer: (PhanideRegexLexerStyler parse: regexDefinition);
		yourself)