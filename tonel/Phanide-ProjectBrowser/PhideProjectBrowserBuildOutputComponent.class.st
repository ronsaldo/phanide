Class {
	#name : #PhideProjectBrowserBuildOutputComponent,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'textView',
		'textMutex'
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
PhideProjectBrowserBuildOutputComponent >> initialize [
	super initialize.
	textMutex := Semaphore forMutualExclusion.
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
