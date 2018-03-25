"
I decorate rubric text by using a Phanide styler.
"
Class {
	#name : #PhanideTextStylerDecorator,
	#superclass : #GLMHighlighterTextStylerDecorator,
	#instVars : [
		'phanideStyler',
		'fileReference'
	],
	#category : 'Phanide-SyntaxHighlighting-Rubric'
}

{ #category : #accessing }
PhanideTextStylerDecorator >> defaultStyler [

	^ PhanideShoutStylerAdapter new
		view: self;
		styler: self
	
]

{ #category : #accessing }
PhanideTextStylerDecorator >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideTextStylerDecorator >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #accessing }
PhanideTextStylerDecorator >> phanideStyler [
	^ phanideStyler
]

{ #category : #accessing }
PhanideTextStylerDecorator >> phanideStyler: anObject [
	phanideStyler := anObject
]

{ #category : #'as yet unclassified' }
PhanideTextStylerDecorator >> styleText: aText [
	phanideStyler ifNil: [ ^ nil ].
	^ phanideStyler styleText: aText fromFileReference: fileReference
]

{ #category : #'as yet unclassified' }
PhanideTextStylerDecorator >> styleText: aText onError: aBlock [
	| result |
	result := nil.
	[
		result := self styleText: aText
	] on: Error do: aBlock.
	^ result
]
