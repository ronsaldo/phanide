as yet unclassified
processOutputLine: line
	| record |
	record := PhanideGDBOutputParser parse: line.
	record isPetitFailure ifTrue: [
		^ [
			self error: 'Failed to parse gdb output record: ' , line printString
		] fork
	].

	record accept: self