accessing
primitiveNextPut: aCharacter
	| codePoint |
	codePoint := aCharacter codePoint.
	codePoint <= 127 ifTrue: [
		stream nextPut: codePoint
	] ifFalse: [
		self halt.
	].