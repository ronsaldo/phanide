"
I am a character class with a single character.
"
Class {
	#name : #PhanideNFACharacterClassCharacter,
	#superclass : #PhanideNFACharacterClass,
	#instVars : [
		'character'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #testing }
PhanideNFACharacterClassCharacter >> acceptsCharacter: aCharacter [
	^ character = aCharacter
]

{ #category : #accessing }
PhanideNFACharacterClassCharacter >> character [
	^ character
]

{ #category : #accessing }
PhanideNFACharacterClassCharacter >> character: anObject [
	character := anObject
]

{ #category : #printing }
PhanideNFACharacterClassCharacter >> printOn: aStream [
	aStream nextPut: character
]
