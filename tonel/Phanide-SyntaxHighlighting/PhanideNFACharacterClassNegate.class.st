"
I represent the negation of a character class.
"
Class {
	#name : #PhanideNFACharacterClassNegate,
	#superclass : #PhanideNFACharacterClass,
	#instVars : [
		'value'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #testing }
PhanideNFACharacterClassNegate >> acceptsCharacter: aCharacter [
	^ (value acceptsCharacter: aCharacter) not
]

{ #category : #printing }
PhanideNFACharacterClassNegate >> printOn: aStream [
	aStream nextPut: $^; print: value
]

{ #category : #accessing }
PhanideNFACharacterClassNegate >> value [
	^ value
]

{ #category : #accessing }
PhanideNFACharacterClassNegate >> value: anObject [
	value := anObject
]
