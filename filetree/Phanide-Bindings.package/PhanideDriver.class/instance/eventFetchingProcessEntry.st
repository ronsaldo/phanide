events
eventFetchingProcessEntry
	| delay |
	delay := Delay forMilliseconds: 100.
	
	[
		(session ~~ Smalltalk session or: [context isNil or: [context isNull]]) ifTrue: [ ^ self ].
		self eventFetchingIteration.
		delay wait
	] repeat