"
I am a grammar for JSON. I am used for providing syntax highlighting for JSON code.

I am a transcription of the grammar defined at: https://www.json.org/

"
Class {
	#name : #PhanideJSONGrammar,
	#superclass : #PP2CompositeNode,
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
	#category : #'Phanide-SyntaxHighlighting-Styler'
}

{ #category : #accessing }
PhanideJSONGrammar >> array [
	^ lbracket , value , (comma , value) star , rbracket
]

{ #category : #accessing }
PhanideJSONGrammar >> colon [
	^ self token: $: asPParser
]

{ #category : #accessing }
PhanideJSONGrammar >> comma [
	^ self token: $, asPParser
]

{ #category : #accessing }
PhanideJSONGrammar >> exponent [
	^ ($e asPParser / $E asPParser), ($+ asPParser / $- asPParser) optional , #digit asPParser plus
]

{ #category : #accessing }
PhanideJSONGrammar >> falseLiteral [
	^ self keyword: 'false'
]

{ #category : #accessing }
PhanideJSONGrammar >> fractionalPart [
	^ $. asPParser, #digit asPParser plus
]

{ #category : #accessing }
PhanideJSONGrammar >> integerPart [
	^ $- asPParser optional , #digit asPParser plus
]

{ #category : #accessing }
PhanideJSONGrammar >> keyword: aString [
	^ self token: aString asPParser
	
]

{ #category : #accessing }
PhanideJSONGrammar >> lbracket [
	^ self token: $[ asPParser
]

{ #category : #accessing }
PhanideJSONGrammar >> lcbracket [
	^ self token: ${ asPParser
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
	^ self token: $] asPParser
]

{ #category : #accessing }
PhanideJSONGrammar >> rcbracket [
	^ self token: $} asPParser
]

{ #category : #accessing }
PhanideJSONGrammar >> space [
	^ #space asPParser plus
]

{ #category : #accessing }
PhanideJSONGrammar >> start [
	^ value
]

{ #category : #accessing }
PhanideJSONGrammar >> string [
	^ self token:
	($" asPParser ,
		(($\ asPParser , #any asPParser) / ($" asPParser negate) ) star,
	$" asPParser)
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
