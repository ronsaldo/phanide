"
A parser for regular expressions into Non Deterministic Finite Automatas.
"
Class {
	#name : #PhanideRegexParser,
	#superclass : #PhanideRegexGrammar,
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #accessing }
PhanideRegexParser >> alternations [
	^ super alternations ==> [ :list |
		| result |
		result := list first.
		list second do: [ :alternative | result := result / alternative second ].
		result
	]
]

{ #category : #accessing }
PhanideRegexParser >> anyMetaCharacter [
	^ super anyMetaCharacter ==> [ :c |
		PhanideNFA metaCharacter: c
	]
]

{ #category : #accessing }
PhanideRegexParser >> characterClass [
	^ super characterClass ==> [ :list |
		| elements result |
		elements := list third.
		result := elements first copy.
		elements allButFirstDo: [ :el | result := result union: el ].
		list second ifNotNil: [ result negated asNFA] ifNil: [ result asNFA]
	]
]

{ #category : #accessing }
PhanideRegexParser >> characterClassEscapeSequence [
	^ super characterClassEscapeSequence ==> [ :seq | seq second ]
]

{ #category : #accessing }
PhanideRegexParser >> characterClassSingleCharacter [
	^ super characterClassSingleCharacter ==> [ :c | 
		PhanideNFACharacterClassCharacter new character: c
	]
]

{ #category : #accessing }
PhanideRegexParser >> characterRange [
	^ super characterRange ==> [ :list | 
		PhanideNFACharacterClassRange new start: list first; stop: list third
	]
]

{ #category : #accessing }
PhanideRegexParser >> characterTerm [
	^ super characterTerm ==> [ :c | PhanideNFA character: c ]
]

{ #category : #accessing }
PhanideRegexParser >> escapeSequence [
	^ super escapeSequence ==> [ :c | PhanideNFA escapeSequence: c ]
]

{ #category : #accessing }
PhanideRegexParser >> parent [
	^ super parent ==> [ :l | l second ]
]

{ #category : #accessing }
PhanideRegexParser >> repetition [
	^ super repetition ==> [:list |
		list second ifNil: [ list first ] ifNotNil: [ list first repetitionOfType: list second ]
	]
]

{ #category : #accessing }
PhanideRegexParser >> sequence [
	^ super sequence ==> [ :list |
		| result |
		result := PhanideNFA epsilon.
		list do: [ :el | result := result , el ].
		result
	]
]
