Class {
	#name : #PhideProjectBrowserDebuggerConsole,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'textView',
		'textMutex'
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
PhideProjectBrowserDebuggerConsole >> initialize [
	super initialize.
	textMutex := Semaphore forMutualExclusion.
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
