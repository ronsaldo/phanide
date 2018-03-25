"
A grammar for Regular expressions..
"
Class {
	#name : #PhanideRegexGrammar,
	#superclass : #PPCompositeParser,
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
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #accessing }
PhanideRegexGrammar >> alternations [
	^ sequence, ($| asParser , sequence) star
]

{ #category : #accessing }
PhanideRegexGrammar >> anyMetaCharacter [
	^ $. asParser
]

{ #category : #accessing }
PhanideRegexGrammar >> characterClass [
	^ $[ asParser, $^ asParser optional, characterClassElement plus , $] asParser
]

{ #category : #accessing }
PhanideRegexGrammar >> characterClassCharacter [
	^ ($- asParser / $] asParser) negate
]

{ #category : #accessing }
PhanideRegexGrammar >> characterClassElement [
	^ namedCharacterClass / characterRange / characterClassSingleCharacter
]

{ #category : #accessing }
PhanideRegexGrammar >> characterClassEscapeSequence [
	^ $\ asParser , #any asParser
]

{ #category : #accessing }
PhanideRegexGrammar >> characterClassSingleCharacter [
	^ characterClassEscapeSequence / characterClassCharacter
]

{ #category : #accessing }
PhanideRegexGrammar >> characterRange [
	^ characterRangeBound , $- asParser , characterRangeBound
]

{ #category : #accessing }
PhanideRegexGrammar >> characterRangeBound [
	^ characterClassEscapeSequence / characterClassCharacter
]

{ #category : #accessing }
PhanideRegexGrammar >> characterTerm [
	^ ($| asParser / $[ asParser / $( asParser / $) asParser) negate
]

{ #category : #accessing }
PhanideRegexGrammar >> escapeSequence [
	^ ($\ asParser , #any asParser) flatten
]

{ #category : #accessing }
PhanideRegexGrammar >> namedCharacterClass [
	^ '[:' asParser, #letter asParser plus flatten , ':]' asParser
]

{ #category : #accessing }
PhanideRegexGrammar >> parent [
	^ $( asParser , alternations , $) asParser
]

{ #category : #accessing }
PhanideRegexGrammar >> repetition [
	^ term , repetitionOperator optional
]

{ #category : #accessing }
PhanideRegexGrammar >> repetitionOperator [
	^ $* asParser | $+ asParser | $? asParser
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
