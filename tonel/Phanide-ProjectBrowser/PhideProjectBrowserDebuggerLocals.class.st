Class {
	#name : #PhideProjectBrowserDebuggerLocals,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'listView'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowserDebuggerLocals class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #listView;
		yourself
]

{ #category : #testing }
PhideProjectBrowserDebuggerLocals class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhideProjectBrowserDebuggerLocals >> initializePresenters [
	listView := self newTable.
	listView
		beResizable;
		addColumn: (SpStringTableColumn title: 'Name' evaluated: [ :item | item name ]);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: [ :item | item value ])
]

{ #category : #accessing }
PhideProjectBrowserDebuggerLocals >> installLocation [
	^ #rightTopTabs
]

{ #category : #accessing }
PhideProjectBrowserDebuggerLocals >> listView [
	^ listView
]

{ #category : #initialization }
PhideProjectBrowserDebuggerLocals >> modelChanged [
	| project |
	project := self model.
	project whenActiveDebugSessionChangedDo: [ :debugSession |
		debugSession whenCurrentStackFrameChangedDo: [ :newFrame |
			newFrame ifNil: [
				listView items: #()
			] ifNotNil: [
				listView items: (debugSession localsInFrame: newFrame)
			]
		]
	]
]

{ #category : #TOREMOVE }
PhideProjectBrowserDebuggerLocals >> title [
	^ 'Locals'
]
