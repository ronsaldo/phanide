Extension { #name : #String }

{ #category : #'*Phanide-GDB' }
String >> asCStringForGDB [
	^ ByteString streamContents: [ :out |
		self asCStringForGDBInto: out
	]
]

{ #category : #'*Phanide-GDB' }
String >> asCStringForGDBInto: out [
	| utf8String |
	utf8String := self utf8Encoded.
	out nextPut: $".
	utf8String do: [ :char |
		(" " 32 <= char and: [ char <= 126 ]) ifTrue: [
			('"\' includes: char asCharacter) ifTrue: [
				out nextPut: $\; nextPut: char asCharacter
			] ifFalse: [ 
				out nextPut: char asCharacter
			].
		] ifFalse: [
			out nextPutAll: '\x'; nextPutAll: (char printStringBase: 16 length: 2 padded: true) asLowercase
		]
	].
	out nextPut: $".

]
