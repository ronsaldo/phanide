Class {
	#name : #PhideProjectBrowserTextFileEditorComponent,
	#superclass : #PhideProjectBrowserFileEditorComponent,
	#instVars : [
		'textEditor'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowserTextFileEditorComponent class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #textEditor;
		yourself
]

{ #category : #testing }
PhideProjectBrowserTextFileEditorComponent class >> isFallbackEditorFor: aFileReference [
	[
		aFileReference contents 
	] on: Error do: [
		^ false
	].
	^ true
]

{ #category : #initialization }
PhideProjectBrowserTextFileEditorComponent >> initializePresenters [
	textEditor := self newText.

]

{ #category : #accessing }
PhideProjectBrowserTextFileEditorComponent >> textEditor [
	^ textEditor
]
