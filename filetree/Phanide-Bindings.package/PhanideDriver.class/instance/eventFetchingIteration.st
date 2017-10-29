events
eventFetchingIteration
	| event |
	event := LibPhanideEvent new.
	[ context pollEvent: event ] whileTrue: [
		self processEvent: event
	]