"
I am a node of segment tree that is used for building the RunArray for text attributes in a more efficient way.
"
Class {
	#name : #PhanideAttributesSegmentTreeNode,
	#superclass : #Object,
	#instVars : [
		'start',
		'stop',
		'value',
		'left',
		'right'
	],
	#category : 'Phanide-SyntaxHighlighting-Commands'
}

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> children [
	left ifNil: [ ^ #() ].
	^ { left . right }
]

{ #category : #enumerating }
PhanideAttributesSegmentTreeNode >> from: rangeStart to: rangeStop put: newValue [
	rangeStop < start ifTrue: [ ^ self ].
	rangeStart > stop ifTrue: [ ^ self ].
	
	(rangeStart <= start and: [ stop <= rangeStop ]) ifTrue: [
		value := newValue.
		^ self
	].

	self pushDown.
	left from: rangeStart to: rangeStop put: newValue.
	right from: rangeStart to: rangeStop put: newValue.
]

{ #category : #'as yet unclassified' }
PhanideAttributesSegmentTreeNode >> gtInspectorTree: composite [
	<gtInspectorPresentationOrder: 20>
	composite tree 
		title: 'Tree';
		display: [ :root | self ];
		children: [ :each | each children ]
]

{ #category : #enumerating }
PhanideAttributesSegmentTreeNode >> leavesDo: aBlock [
	value ifNotNil: [ ^ aBlock value: self ].
	left leavesDo: aBlock.
	right leavesDo: aBlock
]

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> left [
	^ left
]

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> left: anObject [
	left := anObject
]

{ #category : #printing }
PhanideAttributesSegmentTreeNode >> printOn: aStream [
	aStream print: start; nextPutAll: ' to: '; print: stop; nextPutAll: ' value: '; print: value
]

{ #category : #enumerating }
PhanideAttributesSegmentTreeNode >> pushDown [
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
]

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> right [
	^ right
]

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> right: anObject [
	right := anObject
]

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> size [
	^ stop - start + 1
]

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> start [
	^ start
]

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> start: anObject [
	start := anObject
]

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> stop [
	^ stop
]

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> stop: anObject [
	stop := anObject
]

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> value [
	^ value
]

{ #category : #accessing }
PhanideAttributesSegmentTreeNode >> value: anObject [
	value := anObject
]
