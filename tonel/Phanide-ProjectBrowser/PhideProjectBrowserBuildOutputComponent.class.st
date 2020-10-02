Class {
	#name : #PhideProjectBrowserBuildOutputComponent,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'textView'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowserBuildOutputComponent class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #textView;
		yourself
]

{ #category : #testing }
PhideProjectBrowserBuildOutputComponent class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhideProjectBrowserBuildOutputComponent >> initializePresenters [
	textView := self newText.

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
			textView text: ''.
			messageBlock := [ :message |
				self defer: [
					textView
						text: textView text , message
				]
			].
		
			newSession
				onStdoutMessageDo: messageBlock;
				onStderrMessageDo: messageBlock
		]
	]
]

{ #category : #accessing }
PhideProjectBrowserBuildOutputComponent >> textView [
	^ textView
]

{ #category : #accessing }
PhideProjectBrowserBuildOutputComponent >> title [
	^ 'Build Output'
]
