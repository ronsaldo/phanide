"
I am a segment tree that is used for building the RunArray for text attributes in a more efficient way.
"
Class {
	#name : #PhanideAttributesSegmentTree,
	#superclass : #Object,
	#instVars : [
		'root'
	],
	#category : 'Phanide-SyntaxHighlighting-Commands'
}

{ #category : #'instance creation' }
PhanideAttributesSegmentTree class >> from: start to: stop value: value [
	^ self new initializeFrom: start to: stop value: value
]

{ #category : #converting }
PhanideAttributesSegmentTree >> asArray [
	| result destIndex |
	result := Array new: root size.
	destIndex := 1.
	self leavesDo: [ :leaf |
		1 to: leaf size do: [ :i |
			result at: destIndex put: leaf value.
			destIndex := destIndex + 1
		]
	].
	^ result
]

{ #category : #converting }
PhanideAttributesSegmentTree >> asRunArray [
	| result |
	result := RunArray new.
	self leavesDo: [ :leaf |
		result add: leaf value withOccurrences: leaf size
	].
	^ result
]

{ #category : #'instance creation' }
PhanideAttributesSegmentTree >> from: start to: stop put: newValue [
	self assert: newValue isNotNil.
	root from: start to: stop put: newValue
]

{ #category : #'as yet unclassified' }
PhanideAttributesSegmentTree >> gtInspectorTree: composite [
	<gtInspectorPresentationOrder: 20>
	root gtInspectorTree: composite
]

{ #category : #initialization }
PhanideAttributesSegmentTree >> initializeFrom: start to: stop value: initialValue [
	root := PhanideAttributesSegmentTreeNode new
		start: start;
		stop: stop;
		value: initialValue
]

{ #category : #enumerating }
PhanideAttributesSegmentTree >> leavesDo: aBlock [
	root leavesDo: aBlock
]
