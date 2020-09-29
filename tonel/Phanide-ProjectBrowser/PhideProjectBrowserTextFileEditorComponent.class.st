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

{ #category : #'as yet unclassified' }
PhideProjectBrowserTextFileEditorComponent >> highlightLine: lineNumber [
	self inform: 'TODO: highlightLine: ' , lineNumber asString
]

{ #category : #initialization }
PhideProjectBrowserTextFileEditorComponent >> initializePresenters [
	textEditor := self newRichText
		beEditable;
		textStyler: SpNullTextStyler new;
		yourself
]

{ #category : #hooks }
PhideProjectBrowserTextFileEditorComponent >> loadContentFromFile: fileReference [
	textEditor text: fileReference contents.
	(PhanideStyler forFileReference: fileReference) ifNotNil: [ :styler |
		textEditor textStyler: (styler asSpTextStyler fileReference: fileReference; yourself).
	].
	
	self hasUnsavedChanges: false.
]

{ #category : #accessing }
PhideProjectBrowserTextFileEditorComponent >> textEditor [
	^ textEditor
]
