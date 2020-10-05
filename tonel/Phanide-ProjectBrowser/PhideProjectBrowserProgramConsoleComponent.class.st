Class {
	#name : #PhideProjectBrowserProgramConsoleComponent,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'terminal'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowserProgramConsoleComponent class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #terminal;
		yourself
]

{ #category : #testing }
PhideProjectBrowserProgramConsoleComponent class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhideProjectBrowserProgramConsoleComponent >> initializePresenters [
	terminal := self newTerminal.

]

{ #category : #accessing }
PhideProjectBrowserProgramConsoleComponent >> installLocation [
	^ #bottomTabs
]

{ #category : #initialization }
PhideProjectBrowserProgramConsoleComponent >> modelChanged [
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
				onStdoutMessageDo: messageBlock;
				onStderrMessageDo: messageBlock
		]
	].
	project
		whenActiveLaunchSessionChangedDo: sessionChangeBlock;
		whenActiveDebugSessionChangedDo: sessionChangeBlock
]

{ #category : #accessing }
PhideProjectBrowserProgramConsoleComponent >> terminal [
	^ terminal
]

{ #category : #accessing }
PhideProjectBrowserProgramConsoleComponent >> title [
	^ 'Program Console'
]
