as yet unclassified
match: aString at: startIndex
	| stream matcher |
	stream := aString readStream.
	stream position: startIndex - 1.
	matcher := regex copy.
	(matcher matchesStreamPrefix: stream) ifFalse: [ ^ nil ].
	^ stream position + 1