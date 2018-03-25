"
I represent the union of character classes.
"
Class {
	#name : #PhanideNFACharacterClassUnion,
	#superclass : #PhanideNFACharacterClass,
	#instVars : [
		'components'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #testing }
PhanideNFACharacterClassUnion >> acceptsCharacter: aCharacter [
	^ components detect: [ :comp | comp acceptsCharacter: aCharacter ] ifFound: [ true ] ifNone: [ false ]
]

{ #category : #accessing }
PhanideNFACharacterClassUnion >> components [
	^ components
]

{ #category : #accessing }
PhanideNFACharacterClassUnion >> components: anObject [
	components := anObject
]

{ #category : #printing }
PhanideNFACharacterClassUnion >> printOn: aStream [
	components do: [ :comp | aStream print: comp ]
]

{ #category : #enumerating }
PhanideNFACharacterClassUnion >> union: aCharacterClass [
	^ self class new components: components , { aCharacterClass }
]
