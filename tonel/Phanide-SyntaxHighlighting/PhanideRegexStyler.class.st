"
I represent a Phanide styler that uses regular expressions.
"
Class {
	#name : #PhanideRegexStyler,
	#superclass : #PhanideStyler,
	#instVars : [
		'lexer'
	],
	#category : 'Phanide-SyntaxHighlighting-Styler'
}

{ #category : #accessing }
PhanideRegexStyler >> lexer [
	^ lexer
]

{ #category : #accessing }
PhanideRegexStyler >> lexer: anObject [
	lexer := anObject
]

{ #category : #'as yet unclassified' }
PhanideRegexStyler >> styleText: aText fromFileReference: aFileReference [
	^ lexer styleText: aText
]
