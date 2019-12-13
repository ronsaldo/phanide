"
I am a parser for an output record from the GDB Machine Interface.
"
Class {
	#name : #PhanideGDBOutputParser,
	#superclass : #PhanideGDBOutputGrammar,
	#classVars : [
		'CScapeCharacter'
	],
	#category : 'Phanide-GDB-Output'
}

{ #category : #initialization }
PhanideGDBOutputParser class >> initialize [
	CScapeCharacter := Dictionary newFromPairs: { 
		$a . 16r07 asCharacter.
		$b . 16r08 asCharacter.
		$f . 16r0c asCharacter.
		$n . Character lf.
		$r . Character cr.
		$t . Character tab.
		$v . 16r0b asCharacter.
		$' . $'.
		$" . $".
		$\ . $\.
	}.
	
]

{ #category : #records }
PhanideGDBOutputParser >> consoleStreamRecord [
	^ super consoleStreamRecord ==> [ :tok | PhanideGDBConsoleStreamRecord new value: tok second ]
]

{ #category : #accessing }
PhanideGDBOutputParser >> cstring [
	^ super cstring ==> [ :token |
		self parseCString: token second
	]

]

{ #category : #accessing }
PhanideGDBOutputParser >> emptyList [
	^ super emptyList ==> [ :tok | #() ]
]

{ #category : #accessing }
PhanideGDBOutputParser >> emptyTuple [
	^ super emptyTuple ==> [ :tok | OrderedDictionary new ]
]

{ #category : #records }
PhanideGDBOutputParser >> endRecord [
	^ super endRecord ==> [ :tok | PhanideGDBEndRecord new ]
]

{ #category : #records }
PhanideGDBOutputParser >> execAsyncRecord [
	^ super execAsyncRecord ==> [ :tok |
		PhanideGDBExecAsyncOutput new
			token: tok first;
			asyncClass: tok third;
			results: tok fourth;
			yourself
		]
]

{ #category : #records }
PhanideGDBOutputParser >> logStreamRecord [
	^ super logStreamRecord ==> [ :tok | PhanideGDBLogStreamRecord new value: tok second ]
]

{ #category : #accessing }
PhanideGDBOutputParser >> nonEmptyList [
	^ super nonEmptyList ==> [ :tok | tok second ]
]

{ #category : #accessing }
PhanideGDBOutputParser >> nonEmptyTuple [
	^ super nonEmptyTuple ==> [ :tok |
		OrderedDictionary newFrom: {tok second} , (tok third collect: #second)
	]
]

{ #category : #records }
PhanideGDBOutputParser >> notifyAsyncOutputRecord [
	^ super notifyAsyncOutputRecord ==> [ :tok |
		PhanideGDBNotifyAsyncOutput new
			token: tok first;
			asyncClass: tok third;
			results: tok fourth;
			yourself
		]
]

{ #category : #accessing }
PhanideGDBOutputParser >> parseCEscapeSequenceFrom: in into: out [
	| c codePoint |
	c := in next.
	CScapeCharacter at: c ifPresent: [ :v |
		out nextPut: v asInteger.
		^ self
	].

	"Hex"
	c = $x ifTrue: [
		codePoint := Integer readFrom: (in next: 2) base: 16.
		out nextPut: codePoint.
		^ self
	].

	"Octal"
	c isDigit ifTrue: [
		codePoint := Integer readFrom: c asString , (in next: 2) base: 8.
		out nextPut: codePoint.
		^ self
	].

	self error: 'Unsupported C escape character ' , c asString
]

{ #category : #accessing }
PhanideGDBOutputParser >> parseCString: content [
	| in c |
	^ (ByteArray streamContents: [ :out |
		in := ReadStream on: content.
		[in atEnd] whileFalse: [
			c := in next.
			c = $\ ifTrue: [
				self parseCEscapeSequenceFrom: in into: out
			] ifFalse: [
				out nextPut: c asInteger
			]
		].
	]) utf8Decoded
]

{ #category : #accessing }
PhanideGDBOutputParser >> result [
	^ super result ==> [ :tok |
		tok first -> tok third
	]
]

{ #category : #accessing }
PhanideGDBOutputParser >> resultListContent [
	^ super resultListContent ==> [ :tok | { tok first } , (tok second collect: #second) ]
]

{ #category : #records }
PhanideGDBOutputParser >> resultRecord [
	^ super resultRecord ==> [ :tok |
		PhanideGDBResultRecord new
			token: tok first;
			resultClass: tok third;
			results: tok fourth;
			yourself
		]
]

{ #category : #accessing }
PhanideGDBOutputParser >> results [
	^ super results ==> [ :tok |
		OrderedDictionary newFrom: (tok collect: #second)
	]
]

{ #category : #records }
PhanideGDBOutputParser >> statusAsyncRecord [
	^ super statusAsyncRecord ==> [ :tok |
		PhanideGDBStatusAsyncOutput new
			token: tok first;
			asyncClass: tok third;
			results: tok fourth;
			yourself
		]
]

{ #category : #records }
PhanideGDBOutputParser >> targetStreamRecord [
	^ super targetStreamRecord ==> [ :tok | PhanideGDBTargetStreamRecord new value: tok second ]
]

{ #category : #accessing }
PhanideGDBOutputParser >> valueListContent [
	^ super valueListContent ==> [ :tok | { tok first } , (tok second collect: #second) ]
]

{ #category : #accessing }
PhanideGDBOutputParser >> variable [
	^ super variable ==> [ :token | token asSymbol ]

]
