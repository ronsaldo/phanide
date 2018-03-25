Class {
	#name : #PhanideHighlighterTextRubEditingMode,
	#superclass : #GLMHighlighterTextRubEditingMode,
	#instVars : [
		'browserComponent'
	],
	#category : 'Phanide-SyntaxHighlighting-Rubric'
}

{ #category : #accessing }
PhanideHighlighterTextRubEditingMode >> browserComponent [
	^ browserComponent
]

{ #category : #accessing }
PhanideHighlighterTextRubEditingMode >> browserComponent: anObject [
	browserComponent := anObject
]

{ #category : #menu }
PhanideHighlighterTextRubEditingMode >> menu [
	browserComponent ifNotNil: [ browserComponent textMenu ].
	^ super menu
]
