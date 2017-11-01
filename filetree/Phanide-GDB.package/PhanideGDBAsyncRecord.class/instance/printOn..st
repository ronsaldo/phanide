printing
printOn: aStream
	aStream print: token; space; nextPutAll: self recordTypeName;
		space; print: asyncClass; space; print: results