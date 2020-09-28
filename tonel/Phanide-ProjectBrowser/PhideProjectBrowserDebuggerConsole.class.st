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

{ #category : #initialization }
PhideProjectBrowserDebuggerConsole >> modelChanged [
	| project sessionChangeBlock |
	project := self model project.
	sessionChangeBlock := [ :newSession |
		newSession ifNotNil: [
			| messageBlock |
			self makeActivePage.
			textView text: ''.
			messageBlock := [ :message |
				textMutex critical: [
					textView
						text: textView text , message
				]
			].
		
			newSession
				onDebuggerStdoutMessageDo: messageBlock;
				onDebuggerStderrMessageDo: messageBlock
		]
	].
	project
		whenActiveDebugSessionChangedDo: sessionChangeBlock
]

{ #category : #accessing }
PhideProjectBrowserDebuggerConsole >> textView [
	^ textView
]

{ #category : #accessing }
PhideProjectBrowserDebuggerConsole >> title [
	^ 'Debugger Console'
]
