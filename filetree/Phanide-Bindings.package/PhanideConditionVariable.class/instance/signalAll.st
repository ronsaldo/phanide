communication
signalAll
	mutex critical: [
		waitingQueue do: #resume.
		waitingQueue removeAll
	]