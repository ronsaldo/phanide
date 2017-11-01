as yet unclassified
outputReadingProcessEntry
	| stdout line |
	stdout := process stdout textStream.
	[(line := stdout nextLine)] whileNotNil: [ 
		self processOutputLine: line.
	]
