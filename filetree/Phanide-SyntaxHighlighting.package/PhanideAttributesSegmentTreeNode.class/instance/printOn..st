printing
printOn: aStream
	aStream print: start; nextPutAll: ' to: '; print: stop; nextPutAll: ' value: '; print: value