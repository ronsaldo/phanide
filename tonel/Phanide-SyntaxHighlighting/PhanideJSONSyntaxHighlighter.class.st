"
I am a syntax higlighter for JSON.
"
Class {
	#name : #PhanideJSONSyntaxHighlighter,
	#superclass : #PhanideJSONGrammar,
	#instVars : [
		'commands'
	],
	#category : 'Phanide-SyntaxHighlighting-Styler'
}

{ #category : #accessing }
PhanideJSONSyntaxHighlighter class >> ignoredNames [
	^ super ignoredNames, #(commands)
]

{ #category : #accessing }
PhanideJSONSyntaxHighlighter >> commands [ 
	^ commands ifNil: [ commands := OrderedCollection new ]
]

{ #category : #accessing }
PhanideJSONSyntaxHighlighter >> keyword: aKeyword [
	^ (super keyword: aKeyword) ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle keyword token: token)
	]
]

{ #category : #accessing }
PhanideJSONSyntaxHighlighter >> lbracket [
	^ super lbracket ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle bracket token: token)
	]
]

{ #category : #accessing }
PhanideJSONSyntaxHighlighter >> lcbracket [
	^ super lcbracket ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle bracket token: token)
	]
]

{ #category : #accessing }
PhanideJSONSyntaxHighlighter >> number [
	^ super number ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle number token: token)
	]
]

{ #category : #accessing }
PhanideJSONSyntaxHighlighter >> pair [
	^ super pair ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle keyword token: tokens first);
			add: (PhanideHighlightCommandStyle operator token: tokens second).
		tokens
	]
]

{ #category : #accessing }
PhanideJSONSyntaxHighlighter >> rbracket [
	^ super rbracket ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle bracket token: token)
	]
]

{ #category : #accessing }
PhanideJSONSyntaxHighlighter >> rcbracket [
	^ super rcbracket ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle bracket token: token)
	]
]

{ #category : #accessing }
PhanideJSONSyntaxHighlighter >> string [
	^ super string ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle string token: token).
		token
	]
]
