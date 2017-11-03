tests
testParseDefinition
	| lexer |
	lexer := PhanideRegexLexer parse: TestDefinition.
	self assert: lexer states size equals: 2.
	self assert: lexer initialState equals: #init.