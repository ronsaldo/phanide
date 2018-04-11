"
This command copies the highlighting style of another text.
"
Class {
	#name : #PhanideHighlightCommandCopyFromText,
	#superclass : #PhanideHighlightCommand,
	#instVars : [
		'text'
	],
	#category : #'Phanide-SyntaxHighlighting-Commands'
}

{ #category : #'as yet unclassified' }
PhanideHighlightCommandCopyFromText >> executeOnSegmentTree: tree withStyleTable: styleTable [
	| currentIndex |
	currentIndex := start.
	text runs runsAndValuesDo: [ :runLength :attributes |
		tree from: currentIndex to: currentIndex + runLength - 1 put: attributes.
		currentIndex := currentIndex + runLength
	]
]

{ #category : #accessing }
PhanideHighlightCommandCopyFromText >> text [
	^ text
]

{ #category : #accessing }
PhanideHighlightCommandCopyFromText >> text: anObject [
	text := anObject
]
