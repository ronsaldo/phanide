enumerating
pushDown
	| middle |
	value ifNil: [ ^ self ].
	self assert: start ~= stop.
	left ifNil: [
		self assert: right isNil.
		middle := start + ((stop - start) // 2).
		left := self class new
			start: start;
			stop: middle.
		right := self class new
			start: middle + 1;
			stop: stop.
	].

	left value: value.
	right value: value.
	value := nil