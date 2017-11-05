initialization
escapeSequence: sequence
	^ EscapeSequences at: sequence ifAbsent: [ self character: sequence second ]