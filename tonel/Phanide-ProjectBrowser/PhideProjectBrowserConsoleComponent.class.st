Class {
	#name : #PhideProjectBrowserConsoleComponent,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'textView'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowserConsoleComponent class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #textView;
		yourself
]

{ #category : #testing }
PhideProjectBrowserConsoleComponent class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhideProjectBrowserConsoleComponent >> initializePresenters [
	textView := self newText.

]

{ #category : #accessing }
PhideProjectBrowserConsoleComponent >> installLocation [
	^ #bottomTabs
]

{ #category : #accessing }
PhideProjectBrowserConsoleComponent >> textView [
	^ textView
]

{ #category : #TOREMOVE }
PhideProjectBrowserConsoleComponent >> title [
	^ 'Console'
]
