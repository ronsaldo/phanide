"
I am a character class that accepts according to a predicate.
"
Class {
	#name : #PhanideNFACharacterClassPredicate,
	#superclass : #PhanideNFACharacterClass,
	#instVars : [
		'name',
		'block'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #testing }
PhanideNFACharacterClassPredicate >> acceptsCharacter: aCharacter [
	^ block value: aCharacter
]

{ #category : #accessing }
PhanideNFACharacterClassPredicate >> block [
	^ block
]

{ #category : #accessing }
PhanideNFACharacterClassPredicate >> block: anObject [
	block := anObject
]

{ #category : #accessing }
PhanideNFACharacterClassPredicate >> name [
	^ name
]

{ #category : #accessing }
PhanideNFACharacterClassPredicate >> name: anObject [
	name := anObject
]

{ #category : #testing }
PhanideNFACharacterClassPredicate >> printOn: aStream [
	aStream nextPutAll: name
]
