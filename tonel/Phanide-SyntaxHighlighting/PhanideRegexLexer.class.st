"
I am a lexer.

I am implemented by using regular expressions.
"
Class {
	#name : #PhanideRegexLexer,
	#superclass : #Object,
	#instVars : [
		'states',
		'initialState'
	],
	#category : #'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #parsing }
PhanideRegexLexer class >> parse: aDefinition [
	^ self new parse: aDefinition
]

{ #category : #accessing }
PhanideRegexLexer >> initialState [
	^ initialState
]

{ #category : #accessing }
PhanideRegexLexer >> initialState: anObject [
	initialState := anObject
]

{ #category : #parsing }
PhanideRegexLexer >> parse: aDefinition [
	| stateRules |
	states := Dictionary new.
	initialState := aDefinition first.
	aDefinition allButFirstDo: [ :stateDefinition |
		stateRules := PhanideRegexLexerStateRules parse: stateDefinition.
		states at: stateRules name put: stateRules
	].
]

{ #category : #'as yet unclassified' }
PhanideRegexLexer >> scanStream: aStream with: aBlock [
	| currentState currentRules |
	currentState := initialState.
	[ aStream atEnd ] whileFalse: [
		currentRules := states at: currentState.
		currentState := currentRules scanStream: aStream with: currentState doing: aBlock 
	]
]

{ #category : #'as yet unclassified' }
PhanideRegexLexer >> scanText: aString [
	^ self scanText: aString with: [ :rule :state :start :stop | ]

]

{ #category : #'as yet unclassified' }
PhanideRegexLexer >> scanText: aString with: aBlock [
	^ self scanStream: aString readStream with: aBlock

]

{ #category : #accessing }
PhanideRegexLexer >> states [
	^ states
]

{ #category : #accessing }
PhanideRegexLexer >> states: anObject [
	states := anObject
]
