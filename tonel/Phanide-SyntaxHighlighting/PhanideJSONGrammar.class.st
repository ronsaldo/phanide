"
I am a grammar for JSON. I am used for providing syntax highlighting for JSON code.

I am a transcription of the grammar defined at: https://www.json.org/

"
Class {
	#name : #PhanideJSONGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'value',
		'string',
		'number',
		'object',
		'array',
		'trueLiteral',
		'falseLiteral',
		'nullLiteral',
		'space',
		'lbracket',
		'comma',
		'rbracket',
		'lcbracket',
		'objectMembers',
		'rcbracket',
		'pair',
		'colon',
		'integerPart',
		'fractionalPart',
		'exponent'
	],
	#category : 'Phanide-SyntaxHighlighting-Styler'
}

{ #category : #accessing }
PhanideJSONGrammar >> array [
	^ lbracket , value , (comma , value) star , rbracket
]

{ #category : #accessing }
PhanideJSONGrammar >> colon [
	^ self token: $: asParser
]

{ #category : #accessing }
PhanideJSONGrammar >> comma [
	^ self token: $, asParser
]

{ #category : #accessing }
PhanideJSONGrammar >> exponent [
	^ ($e asParser / $E asParser), ($+ asParser / $- asParser) optional , #digit asParser plus
]

{ #category : #accessing }
PhanideJSONGrammar >> falseLiteral [
	^ self keyword: 'false'
]

{ #category : #accessing }
PhanideJSONGrammar >> fractionalPart [
	^ $. asParser, #digit asParser plus
]

{ #category : #accessing }
PhanideJSONGrammar >> integerPart [
	^ $- asParser optional , ($0 asParser / (($1 to: $9) asParser , #digit asParser star))
]

{ #category : #accessing }
PhanideJSONGrammar >> keyword: aString [
	^ self token: aString asParser
	
]

{ #category : #accessing }
PhanideJSONGrammar >> lbracket [
	^ self token: $[ asParser
]

{ #category : #accessing }
PhanideJSONGrammar >> lcbracket [
	^ self token: ${ asParser
]

{ #category : #accessing }
PhanideJSONGrammar >> nullLiteral [
	^ self keyword: 'null'
]

{ #category : #accessing }
PhanideJSONGrammar >> number [
	^ self token: integerPart , fractionalPart optional, exponent optional
]

{ #category : #accessing }
PhanideJSONGrammar >> object [
	^ lcbracket , objectMembers optional , rcbracket
]

{ #category : #accessing }
PhanideJSONGrammar >> objectMembers [
	^ pair , (comma, pair) star
]

{ #category : #accessing }
PhanideJSONGrammar >> pair [
	^ string , colon, value
]

{ #category : #accessing }
PhanideJSONGrammar >> rbracket [
	^ self token: $] asParser
]

{ #category : #accessing }
PhanideJSONGrammar >> rcbracket [
	^ self token: $} asParser
]

{ #category : #accessing }
PhanideJSONGrammar >> space [
	^ #space asParser plus
]

{ #category : #accessing }
PhanideJSONGrammar >> start [
	^ value
]

{ #category : #accessing }
PhanideJSONGrammar >> string [
	^ self token:
	($" asParser ,
		(($\ asParser , #any asParser) / ($" asParser negate) ) star,
	$" asParser)
]

{ #category : #accessing }
PhanideJSONGrammar >> token: aParser [
	^ aParser token trim: space
]

{ #category : #accessing }
PhanideJSONGrammar >> trueLiteral [
	^ self keyword: 'true'
]

{ #category : #accessing }
PhanideJSONGrammar >> value [
	^ string / number / object / array / trueLiteral / falseLiteral / nullLiteral
]
