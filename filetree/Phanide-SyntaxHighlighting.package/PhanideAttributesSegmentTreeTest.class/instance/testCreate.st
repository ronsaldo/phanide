tests
testCreate
	| tree data |
	tree := PhanideAttributesSegmentTree from: 1 to: 10 value: #().
	data := tree asArray.
	self assert: data equals: #(
		()
		()
		()
		()
		()
		()
		()
		()
		()
		()
	)
	