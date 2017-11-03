tests
testStyle
	| lexer styles |
	lexer := PhanideRegexLexerStyler parse: TestDefinition.
	styles := OrderedCollection new.
	lexer styleText: '/* Hello World */ 0123456 anIdentifier' withBlock: [ :style :start :stop |
		styles add: { style . start . stop }
	].
	self assert: styles size equals: 7.