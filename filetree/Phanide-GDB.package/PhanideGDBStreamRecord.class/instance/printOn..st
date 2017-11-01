printing
printOn: aStream
	aStream nextPutAll: self recordTypeName; space; print: value.