"
I am a state transition that is trigerered when a character  belongs to a character class.
"
Class {
	#name : #PhanideNFAStateCharacterClassTransition,
	#superclass : #PhanideNFAStateTransition,
	#instVars : [
		'characterClass'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #testing }
PhanideNFAStateCharacterClassTransition >> acceptsCharacter: aCharacter [
	^ characterClass acceptsCharacter: aCharacter
]

{ #category : #accessing }
PhanideNFAStateCharacterClassTransition >> characterClass [
	^ characterClass
]

{ #category : #accessing }
PhanideNFAStateCharacterClassTransition >> characterClass: anObject [
	characterClass := anObject
]

{ #category : #printing }
PhanideNFAStateCharacterClassTransition >> printOn: aStream [
	aStream print: characterClass; nextPutAll: ' -> '; print: targets
]
