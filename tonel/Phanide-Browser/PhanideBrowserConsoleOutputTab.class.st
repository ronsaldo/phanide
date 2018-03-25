"
I represent a console output UI interface.
"
Class {
	#name : #PhanideBrowserConsoleOutputTab,
	#superclass : #PhanideBrowserComponent,
	#instVars : [
		'text'
	],
	#category : 'Phanide-Browser-UI'
}

{ #category : #specs }
PhanideBrowserConsoleOutputTab class >> defaultSpec [
	^ self specLayout
		add: #text
]

{ #category : #testing }
PhanideBrowserConsoleOutputTab class >> isPermanentComponent [
	^ true
]

{ #category : #accessing }
PhanideBrowserConsoleOutputTab >> defaultLabel [
	^ 'Console Output'
]

{ #category : #accessing }
PhanideBrowserConsoleOutputTab >> defaultName [
	^ #MainConsoleOutput
]

{ #category : #initialization }
PhanideBrowserConsoleOutputTab >> initializeWidgets [
	text := self newText
]

{ #category : #'as yet unclassified' }
PhanideBrowserConsoleOutputTab >> installLocation [
	^ #bottomTabs
]

{ #category : #accessing }
PhanideBrowserConsoleOutputTab >> text [
	^ text
]

{ #category : #accessing }
PhanideBrowserConsoleOutputTab >> text: anObject [
	text := anObject
]
