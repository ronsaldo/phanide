as yet unclassified
matchStream: aStream
	| matcher oldPosition |
	matcher := regex copy.
	oldPosition := aStream position.
	(matcher matchesStreamPrefix: aStream) ifFalse: [
		aStream position: oldPosition.
		^ false
	].
	^ true