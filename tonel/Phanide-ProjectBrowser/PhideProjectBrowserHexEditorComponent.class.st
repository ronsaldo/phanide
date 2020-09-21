Class {
	#name : #PhideProjectBrowserHexEditorComponent,
	#superclass : #PhideProjectBrowserFileEditorComponent,
	#instVars : [
		'listView'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowserHexEditorComponent class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #listView;
		yourself
]

{ #category : #initialization }
PhideProjectBrowserHexEditorComponent >> initializePresenters [
	listView := self newTable.

]

{ #category : #accessing }
PhideProjectBrowserHexEditorComponent >> listView [
	^ listView
]
