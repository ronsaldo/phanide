"
I represent a single text style.
"
Class {
	#name : #PhanideSyntaxStyle,
	#superclass : #Object,
	#instVars : [
		'name',
		'textAttributes'
	],
	#category : 'Phanide-SyntaxHighlighting-Style'
}

{ #category : #'as yet unclassified' }
PhanideSyntaxStyle >> applyOn: text from: start to: stop [
	textAttributes do: [ :attr |
		text addAttribute: attr from: start to: stop
	].
]

{ #category : #accessing }
PhanideSyntaxStyle >> name [
	^ name
]

{ #category : #accessing }
PhanideSyntaxStyle >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PhanideSyntaxStyle >> textAttributes [
	^ textAttributes
]

{ #category : #accessing }
PhanideSyntaxStyle >> textAttributes: anObject [
	textAttributes := anObject
]
