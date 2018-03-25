"
A PhanideRegexLexerTest is a test class for testing the behavior of PhanideRegexLexer
"
Class {
	#name : #PhanideRegexLexerTest,
	#superclass : #TestCase,
	#classVars : [
		'TestDefinition'
	],
	#category : 'Phanide-SyntaxHighlighting-Tests'
}

{ #category : #initialization }
PhanideRegexLexerTest class >> initialize [
	TestDefinition := #(init
		(init default
			('/\*' comment -> multiLineComment)
			('[A-Za-z_][A-Za-z_0-9]*' identifier)
			('[0-9]+' number)
			('\s+' space)
		)
	
		(multiLineComment comment
			('\*/' comment -> init)
		)
	).
]

{ #category : #tests }
PhanideRegexLexerTest >> testParseDefinition [
	| lexer |
	lexer := PhanideRegexLexer parse: TestDefinition.
	self assert: lexer states size equals: 2.
	self assert: lexer initialState equals: #init.
]

{ #category : #tests }
PhanideRegexLexerTest >> testStyle [
	| lexer styles |
	lexer := PhanideRegexLexerStyler parse: TestDefinition.
	styles := OrderedCollection new.
	lexer styleText: '/* Hello World */ 0123456 anIdentifier' withBlock: [ :style :start :stop |
		styles add: { style . start . stop }
	].
	self assert: styles size equals: 7
]
