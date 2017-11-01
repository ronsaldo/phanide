accessing
value: aValue
	mutex critical: [ 
		ready ifTrue: [
			self error: 'Future value can only be set once.'
		].

		value := aValue.
		ready := true.
		readyCondition signalAll.
	].
	^ aValue