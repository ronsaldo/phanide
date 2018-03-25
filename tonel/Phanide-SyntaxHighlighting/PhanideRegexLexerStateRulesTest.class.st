"
A PhanideRegexLexerStateRulesTest is a test class for testing the behavior of PhanideRegexLexerStateRules
"
Class {
	#name : #PhanideRegexLexerStateRulesTest,
	#superclass : #TestCase,
	#category : 'Phanide-SyntaxHighlighting-Tests'
}

{ #category : #tests }
PhanideRegexLexerStateRulesTest >> testParseDefinition [
	| stateRules |
	stateRules := PhanideRegexLexerStateRules parse: #(init default
		('/*' comment -> multiLineComment)
		('[A-Za-z_][A-Za-z_0-9]*' identifier)
		('[0-9]+' number)
		('\s+' space)
	).
	
	self assert: stateRules name equals: #init.
	self assert: stateRules rules size equals: 4.
]
