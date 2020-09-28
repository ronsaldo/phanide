Class {
	#name : #PhideProjectBrowserConsoleComponent,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'textView',
		'textMutex'
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
PhideProjectBrowserConsoleComponent >> initialize [
	super initialize.
	textMutex := Semaphore forMutualExclusion.
]

{ #category : #initialization }
PhideProjectBrowserConsoleComponent >> initializePresenters [
	textView := self newText.

]

{ #category : #accessing }
PhideProjectBrowserConsoleComponent >> installLocation [
	^ #bottomTabs
]

{ #category : #initialization }
PhideProjectBrowserConsoleComponent >> modelChanged [
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
				onStdoutMessageDo: messageBlock;
				onStderrMessageDo: messageBlock
		]
	].
	project
		whenActiveLaunchSessionChangedDo: sessionChangeBlock;
		whenActiveDebugSessionChangedDo: sessionChangeBlock
]

{ #category : #accessing }
PhideProjectBrowserConsoleComponent >> textView [
	^ textView
]

{ #category : #TOREMOVE }
PhideProjectBrowserConsoleComponent >> title [
	^ 'Console'
]
