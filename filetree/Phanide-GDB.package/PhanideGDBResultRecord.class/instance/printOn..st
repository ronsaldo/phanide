printing
printOn: aStream
	aStream print: token; space; nextPutAll: self recordTypeName;
		space; print: resultClass; space; print: results