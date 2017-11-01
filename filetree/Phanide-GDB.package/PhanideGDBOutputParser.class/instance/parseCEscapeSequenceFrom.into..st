accessing
parseCEscapeSequenceFrom: in into: out
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