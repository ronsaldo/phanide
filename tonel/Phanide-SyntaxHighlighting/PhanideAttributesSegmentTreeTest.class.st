"
A PhanideAttributesSegmentTreeTest is a test class for testing the behavior of PhanideAttributesSegmentTree
"
Class {
	#name : #PhanideAttributesSegmentTreeTest,
	#superclass : #TestCase,
	#category : 'Phanide-SyntaxHighlighting-Tests'
}

{ #category : #tests }
PhanideAttributesSegmentTreeTest >> testCreate [
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
	
]

{ #category : #tests }
PhanideAttributesSegmentTreeTest >> testSetRange [
	| tree data |
	tree := PhanideAttributesSegmentTree from: 1 to: 10 value: #().
	tree from: 3 to: 5 put: #(red).
	data := tree asArray.
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
	
]

{ #category : #tests }
PhanideAttributesSegmentTreeTest >> testSetRangeAsRunArray [
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
	
]
