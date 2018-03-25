"
I adapt a Phanide styler into a shout styler.
"
Class {
	#name : #PhanideShoutStylerAdapter,
	#superclass : #SHTextStyler,
	#instVars : [
		'styler'
	],
	#category : 'Phanide-SyntaxHighlighting-Rubric'
}

{ #category : #accessing }
PhanideShoutStylerAdapter >> privateFormat: aText [ 
	self flag: 'This feature is not supported for now.'.
	^ aText
]

{ #category : #private }
PhanideShoutStylerAdapter >> privateStyle: aText [ 
	| styledText |
	styler ifNil: [^ self ].
	styledText := styler styleText: aText asString onError: [  ].
	(styledText notNil and: [ styledText ~~ aText ]) ifTrue: [ 
		self flag: 'change only the runs array of the original text.'.
		aText setString: aText string setRunsChecking: styledText runs
	]
]

{ #category : #accessing }
PhanideShoutStylerAdapter >> styler [
	^ styler
]

{ #category : #accessing }
PhanideShoutStylerAdapter >> styler: anObject [
	styler := anObject
]
