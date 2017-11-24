enumerating
from: rangeStart to: rangeStop put: newValue
	rangeStop < start ifTrue: [ ^ self ].
	rangeStart > stop ifTrue: [ ^ self ].
	
	(rangeStart <= start and: [ stop <= rangeStop ]) ifTrue: [
		value := newValue.
		^ self
	].

	self pushDown.
	left from: rangeStart to: rangeStop put: newValue.
	right from: rangeStart to: rangeStop put: newValue.