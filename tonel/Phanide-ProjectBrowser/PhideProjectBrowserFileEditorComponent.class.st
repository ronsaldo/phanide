Class {
	#name : #PhideProjectBrowserFileEditorComponent,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'isTemporary'
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

{ #category : #'as yet unclassified' }
PhideProjectBrowserFileEditorComponent >> makeNonTemporaryEditor [
	self isTemporary ifFalse: [ ^ false ].
	isTemporary := false.
	projectBrowser temporaryEditorIsNoTemporaryAnymore: self.
	self titleChanged
]

{ #category : #TOREMOVE }
PhideProjectBrowserFileEditorComponent >> title [
	^ (self isTemporary ifTrue: [ '*' ] ifFalse: [ '' ]) , self model name
]
