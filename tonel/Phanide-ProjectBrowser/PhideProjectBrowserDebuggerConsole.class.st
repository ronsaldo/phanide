Class {
	#name : #PhideProjectBrowserDebuggerConsole,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'textView'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowserDebuggerConsole class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #textView;
		yourself
]

{ #category : #testing }
PhideProjectBrowserDebuggerConsole class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhideProjectBrowserDebuggerConsole >> initializePresenters [
	textView := self newText.

]

{ #category : #accessing }
PhideProjectBrowserDebuggerConsole >> installLocation [
	^ #rightBottomTabs
]

{ #category : #accessing }
PhideProjectBrowserDebuggerConsole >> textView [
	^ textView
]

{ #category : #TOREMOVE }
PhideProjectBrowserDebuggerConsole >> title [
	^ 'Debugger Console'
]
