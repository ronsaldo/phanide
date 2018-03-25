"
I am a state transition that is trigerered when a character  belongs to a set of characters.
"
Class {
	#name : #PhanideNFAStateCharactersTransition,
	#superclass : #PhanideNFAStateTransition,
	#instVars : [
		'characters'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #testing }
PhanideNFAStateCharactersTransition >> acceptsCharacter: aCharacter [
	^ characters includes: aCharacter
]

{ #category : #accessing }
PhanideNFAStateCharactersTransition >> characters [
	^ characters
]

{ #category : #accessing }
PhanideNFAStateCharactersTransition >> characters: anObject [
	characters := anObject
]

{ #category : #printing }
PhanideNFAStateCharactersTransition >> printOn: aStream [
	aStream print: characters; nextPutAll: ' -> '; print: targets
]
