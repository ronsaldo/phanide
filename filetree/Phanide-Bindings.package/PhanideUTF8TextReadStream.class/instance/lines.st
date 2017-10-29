accessing
lines
	| line |
	^ Array streamContents: [ :out |
		[ line := self nextLine ] whileNotNil: [ 
			out nextPut: line
		]
	]