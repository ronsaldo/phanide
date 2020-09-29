Class {
	#name : #PhideProjectBrowserDebuggerStackTrace,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'listView'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowserDebuggerStackTrace class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #listView;
		yourself
]

{ #category : #testing }
PhideProjectBrowserDebuggerStackTrace class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhideProjectBrowserDebuggerStackTrace >> initializePresenters [
	listView := self newTable.
	listView
		beResizable;
		addColumn: ((SpStringTableColumn title: '#' evaluated: [ :item | item level ])
			width: 25;
			yourself);
		addColumn: (SpStringTableColumn title: 'Function' evaluated: [ :item | item function ]);
		addColumn: (SpStringTableColumn title: 'Address' evaluated: [ :item | item address ]);
		whenActivatedDo: [ :selection | self stackFrameSelected: selection selectedItem ]
]

{ #category : #accessing }
PhideProjectBrowserDebuggerStackTrace >> installLocation [
	^ #rightCenterTabs
]

{ #category : #accessing }
PhideProjectBrowserDebuggerStackTrace >> listView [
	^ listView
]

{ #category : #initialization }
PhideProjectBrowserDebuggerStackTrace >> modelChanged [
	| project |
	project := self model.
	project whenActiveDebugSessionChangedDo: [ :debugSession |
		debugSession whenCurrentStopPointChangedDo: [ :stopPoint |
			|stackTrace|
			(stopPoint isNil or: [stopPoint frame isNil]) ifTrue: [
				listView
					items: #()
			] ifFalse: [ 
				stackTrace := debugSession stackTrace.
				listView
					items: stackTrace.
				(stackTrace includes: stopPoint frame) ifFalse: [
					listView selectItem: stopPoint frame
				]
			].
		]
	]
]

{ #category : #initialization }
PhideProjectBrowserDebuggerStackTrace >> stackFrameSelected: stackFrame [
	self model activeDebugSession ifNotNil: [ :debugSession | debugSession currentStackFrame: stackFrame ]
]

{ #category : #accessing }
PhideProjectBrowserDebuggerStackTrace >> title [
	^ 'Stack trace'
]
