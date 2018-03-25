"
A PhanideRegexLexerRuleTest is a test class for testing the behavior of PhanideRegexLexerRule
"
Class {
	#name : #PhanideRegexLexerRuleTest,
	#superclass : #TestCase,
	#category : 'Phanide-SyntaxHighlighting-Tests'
}

{ #category : #tests }
PhanideRegexLexerRuleTest >> testParseDefinition [
	| rule |
	rule := PhanideRegexLexerRule parse: #('/\*' comment -> multiLineComment).
	self assert: rule style equals: #comment.
	self assert: rule newState equals: #multiLineComment.
	self assert: (rule match: '/* a' at: 1) equals: 3.
	self assert: (rule match: ' /* a' at: 2) equals: 4.

]
