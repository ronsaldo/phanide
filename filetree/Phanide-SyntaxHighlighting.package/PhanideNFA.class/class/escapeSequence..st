initialization
escapeSequence: sequence
	EscapeSequences ifNil: [ self initialize ].
	^ EscapeSequences at: sequence ifAbsent: [ self character: sequence second ]
