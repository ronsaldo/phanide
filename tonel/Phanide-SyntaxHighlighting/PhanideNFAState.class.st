"
I represent a state in a non-deterministic automata.
"
Class {
	#name : #PhanideNFAState,
	#superclass : #Object,
	#instVars : [
		'index',
		'transitions'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #adding }
PhanideNFAState >> addTransition: aTransition [
	transitions add: aTransition
]

{ #category : #copying }
PhanideNFAState >> copyAddingBaseIndex: baseIndex [
	| result |
	result := self class new.
	result transitions: (transitions collect: [ :t | t copyAddingBaseIndex: baseIndex ]).
	^ result
]

{ #category : #copying }
PhanideNFAState >> copyWithRenameDictionary: renameDictionary [
	| result |
	result := self class new.
	result transitions: (transitions collect: [ :t | t copyWithRenameDictionary: renameDictionary ] ).
	^ result
]

{ #category : #accessing }
PhanideNFAState >> index [
	^ index
]

{ #category : #accessing }
PhanideNFAState >> index: anObject [
	index := anObject
]

{ #category : #initialization }
PhanideNFAState >> initialize [
	transitions := OrderedCollection new.
]

{ #category : #testing }
PhanideNFAState >> isOnlyEpsilon [
	transitions ifEmpty: [ ^ false ].
	^ transitions detect: [:x | x isEpsilon not] ifFound: [ false ] ifNone: [ true ]
]

{ #category : #printing }
PhanideNFAState >> printOn: aStream [
	aStream print: index; nextPutAll: ':'; cr.
	transitions do: [ :transition |
		aStream tab; print: transition; cr
	].

]

{ #category : #'as yet unclassified' }
PhanideNFAState >> transitionOnEpsilonTo: target [
	self assert: target isInteger.
	self transitionOnEpsilonToAll: {target}
]

{ #category : #'as yet unclassified' }
PhanideNFAState >> transitionOnEpsilonToAll: targets [
	self addTransition: (PhanideNFAStateEpsilonTransition new targets: targets)
]

{ #category : #'as yet unclassified' }
PhanideNFAState >> transitionTo: target onCharacter: aCharacter [
	self transitionToAll: {target} onCharacters: aCharacter asString
]

{ #category : #'as yet unclassified' }
PhanideNFAState >> transitionTo: target onCharacterClass: aCharacterClass [
	self transitionToAll: {target} onCharacterClass: aCharacterClass
]

{ #category : #'as yet unclassified' }
PhanideNFAState >> transitionTo: target onCharacters: aCollectionOfCharacters [
	self transitionToAll: {target} onCharacters: aCollectionOfCharacters
]

{ #category : #'as yet unclassified' }
PhanideNFAState >> transitionToAll: targets onCharacter: aCharacter [
	self transitionToAll: targets onCharacters: aCharacter asString
]

{ #category : #'as yet unclassified' }
PhanideNFAState >> transitionToAll: targets onCharacterClass: aCharacterClass [
	self addTransition: (PhanideNFAStateCharacterClassTransition new characterClass: aCharacterClass; targets: targets)
]

{ #category : #'as yet unclassified' }
PhanideNFAState >> transitionToAll: targets onCharacters: aCollectionOfCharacters [
	self addTransition: (PhanideNFAStateCharactersTransition new characters: aCollectionOfCharacters; targets: targets)
]

{ #category : #accessing }
PhanideNFAState >> transitions [
	^ transitions
]

{ #category : #accessing }
PhanideNFAState >> transitions: aCollectionOfTransitions [
	transitions := aCollectionOfTransitions
]
