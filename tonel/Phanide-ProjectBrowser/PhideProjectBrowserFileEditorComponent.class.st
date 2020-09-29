Class {
	#name : #PhideProjectBrowserFileEditorComponent,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'isTemporary',
		'hasUnsavedChanges'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #'instance creation' }
PhideProjectBrowserFileEditorComponent class >> editorForFile: aFileReference [
	self allSubclassesDo: [ :sc |
		(sc isSuitableEditorFor: aFileReference) ifTrue: [ 
			^ sc
		]
	].
	self allSubclassesDo: [ :sc |
		(sc isFallbackEditorFor: aFileReference) ifTrue: [ 
			^ sc
		]
	].
	^ PhideProjectBrowserHexEditorComponent
]

{ #category : #testing }
PhideProjectBrowserFileEditorComponent class >> isFallbackEditorFor: aFileReference [
	^ false
]

{ #category : #testing }
PhideProjectBrowserFileEditorComponent class >> isSuitableEditorFor: aFileReference [
	^ false
]

{ #category : #actions }
PhideProjectBrowserFileEditorComponent >> connectPresenters [
	self loadContentFromFile
]

{ #category : #accessing }
PhideProjectBrowserFileEditorComponent >> hasUnsavedChanges [
	^ hasUnsavedChanges ifNil: [ hasUnsavedChanges := false ]
]

{ #category : #accessing }
PhideProjectBrowserFileEditorComponent >> hasUnsavedChanges: aBoolean [
	hasUnsavedChanges := aBoolean.
	self titleChanged
]

{ #category : #'as yet unclassified' }
PhideProjectBrowserFileEditorComponent >> highlightLine: lineNumber [
]

{ #category : #accessing }
PhideProjectBrowserFileEditorComponent >> installLocation [
	^ #contentTabs
]

{ #category : #testing }
PhideProjectBrowserFileEditorComponent >> isCloseable [
	^ true
]

{ #category : #accessing }
PhideProjectBrowserFileEditorComponent >> isTemporary [
	^ isTemporary ifNil: [ isTemporary := false ]
]

{ #category : #accessing }
PhideProjectBrowserFileEditorComponent >> isTemporary: anObject [
	isTemporary := anObject
]

{ #category : #actions }
PhideProjectBrowserFileEditorComponent >> loadContentFromFile [
	self model fileReference ifNotNil: [ :fileReference | self loadContentFromFile: fileReference ]
]

{ #category : #hooks }
PhideProjectBrowserFileEditorComponent >> loadContentFromFile: fileReference [
]

{ #category : #actions }
PhideProjectBrowserFileEditorComponent >> makeNonTemporaryEditor [
	self isTemporary ifFalse: [ ^ false ].
	isTemporary := false.
	projectBrowser temporaryEditorIsNoTemporaryAnymore: self.
	self titleChanged
]

{ #category : #actions }
PhideProjectBrowserFileEditorComponent >> save [
	| fileReference |
	fileReference := self model fileReference.
	fileReference ifNil: [ ^ self saveAs ].
	self saveInto: fileReference.
	self hasUnsavedChanges: false.
	^ true
]

{ #category : #actions }
PhideProjectBrowserFileEditorComponent >> saveInto: targetFileReference [
	self subclassResponsibility
]

{ #category : #accessing }
PhideProjectBrowserFileEditorComponent >> title [
	^ (self hasUnsavedChanges ifTrue: [ '*' ] ifFalse: [ '' ]) ,
		self model name ,
		(self isTemporary ifTrue: [ ' -' ] ifFalse: [ '' ])
]
