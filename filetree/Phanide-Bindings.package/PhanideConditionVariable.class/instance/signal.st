communication
signal
	| process |
	mutex critical: [
		waitingQueue ifNotEmpty: [
			process := waitingQueue removeFirst.
			process resume
		].
	]