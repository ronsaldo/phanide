"
I am a lexer rule. I contain a regular expression, a style name and the name of the next state.
"
Class {
	#name : #PhanideRegexLexerRule,
	#superclass : #Object,
	#instVars : [
		'regex',
		'style',
		'newState'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #parsing }
PhanideRegexLexerRule class >> parse: aRuleDefinition [
	^ self new parse: aRuleDefinition
]

{ #category : #'as yet unclassified' }
PhanideRegexLexerRule >> match: aString at: startIndex [
	| stream matcher |
	stream := aString readStream.
	stream position: startIndex - 1.
	matcher := regex copy.
	(matcher matchesStreamPrefix: stream) ifFalse: [ ^ nil ].
	^ stream position + 1
]

{ #category : #'as yet unclassified' }
PhanideRegexLexerRule >> matchStream: aStream [
	| oldPosition |
	oldPosition := aStream position.
	(regex matchesStreamPrefix: aStream) ifFalse: [
		aStream position: oldPosition.
		^ false
	].
	^ true
]

{ #category : #accessing }
PhanideRegexLexerRule >> newState [
	^ newState
]

{ #category : #accessing }
PhanideRegexLexerRule >> newState: anObject [
	newState := anObject
]

{ #category : #parsing }
PhanideRegexLexerRule >> parse: aRuleDefinition [
	regex := aRuleDefinition first asPhanideRegex.
	style := aRuleDefinition second.
	aRuleDefinition size >= 4 ifTrue: [ 
		self assert: aRuleDefinition third = #->.
		newState := aRuleDefinition fourth
	]
]

{ #category : #accessing }
PhanideRegexLexerRule >> regex [
	^ regex
]

{ #category : #accessing }
PhanideRegexLexerRule >> regex: anObject [
	regex := anObject
]

{ #category : #accessing }
PhanideRegexLexerRule >> style [
	^ style
]

{ #category : #accessing }
PhanideRegexLexerRule >> style: anObject [
	style := anObject
]
