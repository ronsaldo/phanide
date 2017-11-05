as yet unclassified
matchStream: aStream
	| oldPosition |
	oldPosition := aStream position.
	(regex matchesStreamPrefix: aStream) ifFalse: [
		aStream position: oldPosition.
		^ false
	].
	^ true