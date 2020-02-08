"
A grammar for Regular expressions..
"
Class {
	#name : #PhanideRegexGrammar,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'alternations',
		'sequence',
		'term',
		'parent',
		'characterClass',
		'escapeSequence',
		'characterClassElement',
		'namedCharacterClass',
		'characterRange',
		'characterRangeBound',
		'repetition',
		'repetitionOperator',
		'anyMetaCharacter',
		'characterTerm',
		'characterClassCharacter',
		'characterClassEscapeSequence',
		'characterClassSingleCharacter'
	],
	#category : #'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #accessing }
PhanideRegexGrammar >> alternations [
	^ sequence, ($| asPParser , sequence) star
]

{ #category : #accessing }
PhanideRegexGrammar >> anyMetaCharacter [
	^ $. asPParser
]

{ #category : #accessing }
PhanideRegexGrammar >> characterClass [
	^ $[ asPParser, $^ asPParser optional, characterClassElement plus , $] asPParser
]

{ #category : #accessing }
PhanideRegexGrammar >> characterClassCharacter [
	^ ($- asPParser / $] asPParser) negate
]

{ #category : #accessing }
PhanideRegexGrammar >> characterClassElement [
	^ namedCharacterClass / characterRange / characterClassSingleCharacter
]

{ #category : #accessing }
PhanideRegexGrammar >> characterClassEscapeSequence [
	^ $\ asPParser , #any asPParser
]

{ #category : #accessing }
PhanideRegexGrammar >> characterClassSingleCharacter [
	^ characterClassEscapeSequence / characterClassCharacter
]

{ #category : #accessing }
PhanideRegexGrammar >> characterRange [
	^ characterRangeBound , $- asPParser , characterRangeBound
]

{ #category : #accessing }
PhanideRegexGrammar >> characterRangeBound [
	^ characterClassEscapeSequence / characterClassCharacter
]

{ #category : #accessing }
PhanideRegexGrammar >> characterTerm [
	^ ($| asPParser / $[ asPParser / $( asPParser / $) asPParser) negate
]

{ #category : #accessing }
PhanideRegexGrammar >> escapeSequence [
	^ ($\ asPParser , #any asPParser) flatten
]

{ #category : #accessing }
PhanideRegexGrammar >> namedCharacterClass [
	^ '[:' asPParser, #letter asPParser plus flatten , ':]' asPParser
]

{ #category : #accessing }
PhanideRegexGrammar >> parent [
	^ $( asPParser , alternations , $) asPParser
]

{ #category : #accessing }
PhanideRegexGrammar >> repetition [
	^ term , repetitionOperator optional
]

{ #category : #accessing }
PhanideRegexGrammar >> repetitionOperator [
	^ $* asPParser | $+ asPParser | $? asPParser
]

{ #category : #accessing }
PhanideRegexGrammar >> sequence [
	^ repetition star
]

{ #category : #accessing }
PhanideRegexGrammar >> start [
	^ alternations
]

{ #category : #accessing }
PhanideRegexGrammar >> term [
	^ parent / characterClass / escapeSequence / anyMetaCharacter / characterTerm
]
