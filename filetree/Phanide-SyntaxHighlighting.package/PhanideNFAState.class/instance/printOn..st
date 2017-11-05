printing
printOn: aStream
	aStream print: index; nextPutAll: ':'; cr.
	transitions do: [ :transition |
		aStream tab; print: transition; cr
	].
