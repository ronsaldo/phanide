Class {
	#name : #PhideProjectBrowserDebuggerConsole,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'terminal'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowserDebuggerConsole class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #terminal;
		yourself
]

{ #category : #testing }
PhideProjectBrowserDebuggerConsole class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhideProjectBrowserDebuggerConsole >> initializePresenters [
	terminal := self newTerminal.

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
			terminal reset.
			messageBlock := [ :message |
				self defer: [
					terminal receiveTextMessage: message
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
PhideProjectBrowserDebuggerConsole >> terminal [
	^ terminal
]

{ #category : #accessing }
PhideProjectBrowserDebuggerConsole >> title [
	^ 'Debugger Console'
]
