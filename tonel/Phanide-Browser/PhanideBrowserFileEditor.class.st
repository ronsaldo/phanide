"
I represent a file editor.
"
Class {
	#name : #PhanideBrowserFileEditor,
	#superclass : #PhanideBrowserComponent,
	#instVars : [
		'fileReference',
		'temporaryEditor',
		'unsavedChanges'
	],
	#category : 'Phanide-Browser-UI'
}

{ #category : #'as yet unclassified' }
PhanideBrowserFileEditor class >> editorForFile: aFileReference [
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
	^ PhanideBrowserHexEditor
]

{ #category : #initialization }
PhanideBrowserFileEditor class >> initialize [
	SessionManager default registerToolClassNamed: self name
]

{ #category : #testing }
PhanideBrowserFileEditor class >> isFallbackEditorFor: aFileReference [
	^ false
]

{ #category : #testing }
PhanideBrowserFileEditor class >> isSuitableEditorFor: aFileReference [
	^ false
]

{ #category : #'system startup' }
PhanideBrowserFileEditor class >> startUp [
	self allInstancesDo: #tryToReloadForStartup
]

{ #category : #api }
PhanideBrowserFileEditor >> closeable [
	^ true
]

{ #category : #accessing }
PhanideBrowserFileEditor >> defaultLabel [
	^ self labelPrefix , fileReference basename , self labelSuffix
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileEditor >> fileChanged [
]

{ #category : #accessing }
PhanideBrowserFileEditor >> fileName [
	^ fileReference ifNil: [ 'Unnamed' ] ifNotNil: [ fileReference basename ]
]

{ #category : #accessing }
PhanideBrowserFileEditor >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideBrowserFileEditor >> fileReference: anObject [
	fileReference := anObject.
	self fileChanged
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileEditor >> highlightLine: line forDebugStackFrame: stackFrame [
	^ nil
]

{ #category : #initialization }
PhanideBrowserFileEditor >> initialize [
	temporaryEditor := false.
	unsavedChanges := false.
	super initialize.
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileEditor >> installLocation [
	^ #mainTabs
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileEditor >> labelPrefix [
	^ temporaryEditor ifTrue: [ '- ' ] ifFalse: [ '' ]
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileEditor >> labelSuffix [
	^ unsavedChanges ifTrue: [ '*' ] ifFalse: [ '' ]
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileEditor >> makeDirty [
	self unsavedChanges: true.
	self makeTemporaryEditorPermanent.
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileEditor >> makeTemporaryEditorPermanent [
	temporaryEditor ifTrue: [ 
		browser makeTemporaryEditorPermanent: self
	]

]

{ #category : #protocol }
PhanideBrowserFileEditor >> okToClose [
	| choice |
	unsavedChanges ifTrue: [ 
		choice := self promptForCancel.
		choice ifNil: [ ^ false ].
		choice ifTrue: [
			choice := self save.
			choice ifNil: [ ^ false ]
		].
	].
	^ super okToClose
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileEditor >> onAnchorDoubleClick [
	temporaryEditor ifTrue: [ self makeTemporaryEditorPermanent ]
]

{ #category : #accessing }
PhanideBrowserFileEditor >> promptForCancel [
	"Ask for the appropriate action to take when unaccepted contents
	would be overwritten."

	| choice |
	choice := UIManager default
		confirm: ('The contents of {1} has been modified.\What do you want to do?' translated withCRs format: { self fileName })
		trueChoice: 'Saved' translated
		falseChoice: 'Discard' translated
		cancelChoice: 'Cancel' translated
		default: nil.
	^ choice
	
]

{ #category : #actions }
PhanideBrowserFileEditor >> save [
	fileReference ifNil: [ ^ self saveAs ].
	self saveInto: fileReference.
	self unsavedChanges: false.
	^ true
]

{ #category : #actions }
PhanideBrowserFileEditor >> saveAs [
	| targetFile |
	targetFile := UIManager default fileSave: 'Save as' extensions: self validFileExtensions path: (fileReference ifNotNil: [fileReference parent fullName]).
	targetFile ifNil: [ ^ nil ].
	
	"Rename myself"
	fileReference := targetFile asAbsolute.
	self name: fileReference printString.
	
	"Save into the target file."
	self saveInto: fileReference.
	^ true
]

{ #category : #actions }
PhanideBrowserFileEditor >> saveInto: targetFileReference [
	self subclassResponsibility
]

{ #category : #accessing }
PhanideBrowserFileEditor >> temporaryEditor [
	^ temporaryEditor
]

{ #category : #accessing }
PhanideBrowserFileEditor >> temporaryEditor: anObject [
	temporaryEditor := anObject.
	self updateLabel.
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileEditor >> tryToReloadForStartup [
	self fileChanged
]

{ #category : #accessing }
PhanideBrowserFileEditor >> unsavedChanges [
	^ unsavedChanges
]

{ #category : #accessing }
PhanideBrowserFileEditor >> unsavedChanges: aBoolean [
	unsavedChanges == aBoolean ifTrue: [ ^ self ].
	unsavedChanges := aBoolean.
	self updateLabel
]

{ #category : #updating }
PhanideBrowserFileEditor >> updateLabel [
	label ifNotNil: [ self label: self defaultLabel ]
]

{ #category : #actions }
PhanideBrowserFileEditor >> validFileExtensions [
	^ nil
]
