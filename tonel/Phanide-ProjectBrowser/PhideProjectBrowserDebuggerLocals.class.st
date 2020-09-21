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

]

{ #category : #accessing }
PhideProjectBrowserDebuggerLocals >> installLocation [
	^ #rightTopTabs
]

{ #category : #accessing }
PhideProjectBrowserDebuggerLocals >> listView [
	^ listView
]

{ #category : #TOREMOVE }
PhideProjectBrowserDebuggerLocals >> title [
	^ 'Locals'
]
