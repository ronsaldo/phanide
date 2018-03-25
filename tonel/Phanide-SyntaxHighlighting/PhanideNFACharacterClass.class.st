"
I represent a character class. A character is a set of characters.
"
Class {
	#name : #PhanideNFACharacterClass,
	#superclass : #Object,
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #constants }
PhanideNFACharacterClass class >> any [
	^ PhanideNFACharacterClassPredicate new name: 'any'; block: [ :c | true ]
]

{ #category : #constants }
PhanideNFACharacterClass class >> dot [
	^ PhanideNFACharacterClassPredicate new name: '.'; block: [ :c | ((String crlf) includes: c) not ]
]

{ #category : #constants }
PhanideNFACharacterClass class >> white [
	^ PhanideNFACharacterClassPredicate new name: #white; block: [ :c | c isSeparator ]
]

{ #category : #testing }
PhanideNFACharacterClass >> acceptsCharacter: aCharacter [
	self subclassResponsibility
]

{ #category : #converting }
PhanideNFACharacterClass >> asNFA [
	^ PhanideNFA characterClass: self
]

{ #category : #arithmetic }
PhanideNFACharacterClass >> negated [
	^ PhanideNFACharacterClassNegate new value: self
]

{ #category : #enumerating }
PhanideNFACharacterClass >> union: aCharacterClass [
	^ PhanideNFACharacterClassUnion new components: { self . aCharacterClass }
]
