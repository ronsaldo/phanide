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

]

{ #category : #accessing }
PhideProjectBrowserDebuggerStackTrace >> installLocation [
	^ #rightCenterTabs
]

{ #category : #accessing }
PhideProjectBrowserDebuggerStackTrace >> listView [
	^ listView
]

{ #category : #TOREMOVE }
PhideProjectBrowserDebuggerStackTrace >> title [
	^ 'Stack trace'
]
