tests
testSetRangeAsRunArray
	| tree data |
	tree := PhanideAttributesSegmentTree from: 1 to: 10 value: #().
	tree from: 3 to: 5 put: #(red).
	data := tree asRunArray asArray.
	self assert: data equals: #(
		()
		()
		(red)
		(red)
		(red)
		()
		()
		()
		()
		()
	)
	