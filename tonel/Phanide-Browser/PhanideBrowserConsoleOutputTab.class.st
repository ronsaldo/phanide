"
I represent a console output UI interface.
"
Class {
	#name : #PhanideBrowserConsoleOutputTab,
	#superclass : #PhanideBrowserComponent,
	#traits : 'TPhanideBrowserMorphComponent',
	#classTraits : 'TPhanideBrowserMorphComponent classTrait',
	#instVars : [
		'textModel'
	],
	#category : #'Phanide-Browser-UI'
}

{ #category : #testing }
PhanideBrowserConsoleOutputTab class >> isPermanentComponent [
	^ true
]

{ #category : #'acessing text' }
PhanideBrowserConsoleOutputTab >> appendText: aText [
	morph appendText: aText
]

{ #category : #initialization }
PhanideBrowserConsoleOutputTab >> createMorph [
	textModel := RubScrolledTextModel new.
	^ textModel newScrolledText
		color: Smalltalk ui theme backgroundColor;
		textColor: Smalltalk ui theme textColor;
		textFont: StandardFonts codeFont;
		tabWidth: (StandardFonts codeFont characterFormAt: Character space) advance x * 4;
		yourself.

]

{ #category : #accessing }
PhanideBrowserConsoleOutputTab >> defaultLabel [
	^ 'Console Output'
]

{ #category : #accessing }
PhanideBrowserConsoleOutputTab >> defaultName [
	^ #MainConsoleOutput
]

{ #category : #'as yet unclassified' }
PhanideBrowserConsoleOutputTab >> installLocation [
	^ #bottomTabs
]
