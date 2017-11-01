accessing
parseCString: content
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