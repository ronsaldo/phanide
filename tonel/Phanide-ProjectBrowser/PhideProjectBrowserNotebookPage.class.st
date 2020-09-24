Class {
	#name : #PhideProjectBrowserNotebookPage,
	#superclass : #SpNotebookPage,
	#instVars : [
		'projectBrowser',
		'browserComponent'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #accessing }
PhideProjectBrowserNotebookPage >> browserComponent [
	^ browserComponent
]

{ #category : #accessing }
PhideProjectBrowserNotebookPage >> browserComponent: anObject [
	browserComponent := anObject
]

{ #category : #accessing }
PhideProjectBrowserNotebookPage >> projectBrowser [
	^ projectBrowser
]

{ #category : #accessing }
PhideProjectBrowserNotebookPage >> projectBrowser: anObject [
	projectBrowser := anObject
]

{ #category : #accessing }
PhideProjectBrowserNotebookPage >> removeFromNotebook [
	browserComponent ifNotNil: [
		^ browserComponent validateCloseRequestAndCommitWith: [ 
			browserComponent closed.
			super removeFromNotebook
		]
	].

	^ super removeFromNotebook
]
