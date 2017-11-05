accessing
repetition
	^ super repetition ==> [:list |
		list second ifNil: [ list first ] ifNotNil: [ list first repetitionOfType: list second ]
	]