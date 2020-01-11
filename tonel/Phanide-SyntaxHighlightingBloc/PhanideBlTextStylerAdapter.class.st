Class {
	#name : #PhanideBlTextStylerAdapter,
	#superclass : #BlTextStyler,
	#instVars : [
		'phanideStyler',
		'fileReference'
	],
	#category : #'Phanide-SyntaxHighlightingBloc'
}

{ #category : #accessing }
PhanideBlTextStylerAdapter >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideBlTextStylerAdapter >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #accessing }
PhanideBlTextStylerAdapter >> phanideStyler [
	^ phanideStyler
]

{ #category : #accessing }
PhanideBlTextStylerAdapter >> phanideStyler: anObject [
	phanideStyler := anObject
]

{ #category : #private }
PhanideBlTextStylerAdapter >> privateStyle: aText [ 
	<return: #BlText>
	[
		phanideStyler styleBlocText: aText fromFileReference: fileReference withStyleTable: PhanideSyntaxStyleTable currentLightTheme
	] on: Error
		do: [ :ex | ex return ].
	^ aText
]
