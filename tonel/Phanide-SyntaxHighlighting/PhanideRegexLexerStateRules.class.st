"
I represent a sets of rules that makes sense to have them instantiated.
"
Class {
	#name : #PhanideRegexLexerStateRules,
	#superclass : #Object,
	#instVars : [
		'name',
		'rules',
		'defaultStyle',
		'combinedRegex'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #parsing }
PhanideRegexLexerStateRules class >> parse: definition [
	^ self new parse: definition
]

{ #category : #parsing }
PhanideRegexLexerStateRules >> combineRules [
	| acceptingStates initialState regex baseIndex defaultCharacterDetect defaultCharacterAccepting |
	combinedRegex := PhanideNFA new.
	acceptingStates := rules collectWithIndex: [ :r :i | combinedRegex newState ].

	initialState := combinedRegex newState.
	combinedRegex
		initial: initialState index;
		accepting: (acceptingStates collect: #index).
		
	rules doWithIndex: [ :rule :ruleIndex |
		regex := rule regex.
		baseIndex := combinedRegex addCopyingStatesWithBaseIndex: regex states.
		initialState transitionOnEpsilonTo: regex initial + baseIndex.
		regex accepting do: [ :index |
			(combinedRegex states at: index + baseIndex) transitionOnEpsilonTo: (acceptingStates at: ruleIndex) index
		]
	]. 

	"Add a default state"
	defaultCharacterDetect := combinedRegex newState.
	defaultCharacterAccepting := combinedRegex newState.
	combinedRegex accepting: (combinedRegex accepting , { defaultCharacterAccepting index }).
	defaultCharacterDetect transitionTo: defaultCharacterAccepting index onCharacterClass: PhanideNFACharacterClass any. 
	initialState transitionOnEpsilonTo: defaultCharacterDetect index.
	
	combinedRegex := combinedRegex simplified.
]

{ #category : #accessing }
PhanideRegexLexerStateRules >> defaultStyle [
	^ defaultStyle
]

{ #category : #accessing }
PhanideRegexLexerStateRules >> defaultStyle: anObject [
	defaultStyle := anObject
]

{ #category : #accessing }
PhanideRegexLexerStateRules >> name [
	^ name
]

{ #category : #accessing }
PhanideRegexLexerStateRules >> name: anObject [
	name := anObject
]

{ #category : #parsing }
PhanideRegexLexerStateRules >> parse: definition [
	name := definition first.
	defaultStyle := definition second.
	rules := (definition allButFirst: 2) collect: [ :r | PhanideRegexLexerRule parse: r ].
	self combineRules.
]

{ #category : #accessing }
PhanideRegexLexerStateRules >> rules [
	^ rules
]

{ #category : #'as yet unclassified' }
PhanideRegexLexerStateRules >> scanStream: aStream with: startState doing: aBlock [

	| finalState startPosition endPosition tokenStartPosition rule |
	startPosition := aStream position.
	[
		tokenStartPosition := aStream position.
		finalState := combinedRegex simulateStreamForPrefix: aStream.
		endPosition := aStream position.
	] doWhileFalse: [ finalState bestAcceptingState <= rules size or: [aStream atEnd]].

	startPosition ~= tokenStartPosition ifTrue: [
		aBlock value: nil value: self value: startPosition + 1 value: tokenStartPosition
	].

	(finalState bestAcceptingState <= rules size) ifTrue: [
		rule := rules at: finalState bestAcceptingState.
		aBlock value: rule value: self value: tokenStartPosition + 1 value: endPosition.
		^ rule newState ifNil: [ startState ]
	].

	^ startState
]
