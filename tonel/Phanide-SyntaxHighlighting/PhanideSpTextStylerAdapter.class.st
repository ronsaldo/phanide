Class {
	#name : #PhanideSpTextStylerAdapter,
	#superclass : #SpTextStyler,
	#instVars : [
		'phanideStyler',
		'fileReference'
	],
	#category : #'Phanide-SyntaxHighlighting-Spec2'
}

{ #category : #applying }
PhanideSpTextStylerAdapter >> applyStyleTo: aString [
	^ phanideStyler styleText: aString fromFileReference: fileReference
]

{ #category : #accessing }
PhanideSpTextStylerAdapter >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideSpTextStylerAdapter >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #accessing }
PhanideSpTextStylerAdapter >> phanideStyler [
	^ phanideStyler
]

{ #category : #accessing }
PhanideSpTextStylerAdapter >> phanideStyler: anObject [
	phanideStyler := anObject
]
