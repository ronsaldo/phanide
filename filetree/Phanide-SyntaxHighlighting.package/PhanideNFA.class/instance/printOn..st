printing
printOn: aStream
	aStream print: initial; space; print: accepting; cr.
	states do: [ :state | aStream print: state ]