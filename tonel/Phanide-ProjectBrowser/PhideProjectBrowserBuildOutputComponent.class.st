Class {
	#name : #PhideProjectBrowserBuildOutputComponent,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'terminal'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowserBuildOutputComponent class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #terminal;
		yourself
]

{ #category : #testing }
PhideProjectBrowserBuildOutputComponent class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhideProjectBrowserBuildOutputComponent >> initializePresenters [
	terminal := self newTerminal.

]

{ #category : #accessing }
PhideProjectBrowserBuildOutputComponent >> installLocation [
	^ #bottomTabs
]

{ #category : #initialization }
PhideProjectBrowserBuildOutputComponent >> modelChanged [
	| project |
	project := self model project.
	project whenActiveBuildSessionChangedDo: [ :newSession |
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
	]
]

{ #category : #accessing }
PhideProjectBrowserBuildOutputComponent >> terminal [
	^ terminal
]

{ #category : #accessing }
PhideProjectBrowserBuildOutputComponent >> title [
	^ 'Build Output'
]
