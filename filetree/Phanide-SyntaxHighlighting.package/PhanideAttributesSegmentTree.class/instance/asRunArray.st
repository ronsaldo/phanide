converting
asRunArray
	| result |
	result := RunArray new.
	self leavesDo: [ :leaf |
		result add: leaf value withOccurrences: leaf size
	].
	^ result