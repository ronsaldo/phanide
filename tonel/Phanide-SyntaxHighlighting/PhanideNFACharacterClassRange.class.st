"
I represent the set of characters inside an inclusive range.
"
Class {
	#name : #PhanideNFACharacterClassRange,
	#superclass : #PhanideNFACharacterClass,
	#instVars : [
		'start',
		'stop'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #testing }
PhanideNFACharacterClassRange >> acceptsCharacter: aCharacter [
	^ start <= aCharacter and: [ aCharacter <= stop ]
]

{ #category : #printing }
PhanideNFACharacterClassRange >> printOn: aStream [
	aStream nextPut: start; nextPut: $-; nextPut: stop
]

{ #category : #accessing }
PhanideNFACharacterClassRange >> start [
	^ start
]

{ #category : #accessing }
PhanideNFACharacterClassRange >> start: anObject [
	start := anObject
]

{ #category : #accessing }
PhanideNFACharacterClassRange >> stop [
	^ stop
]

{ #category : #accessing }
PhanideNFACharacterClassRange >> stop: anObject [
	stop := anObject
]
