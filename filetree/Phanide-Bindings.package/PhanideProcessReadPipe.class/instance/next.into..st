accessing
next: n into: aBuffer
	| resultCount |
	resultCount := self read: n into: aBuffer.
	^ resultCount = n
		ifTrue: [ aBuffer ]
		ifFalse: [ aBuffer copyFrom: 1 to: resultCount ].