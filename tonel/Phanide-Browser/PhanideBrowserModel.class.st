"
I am the main Phanide browser UI.
"
Class {
	#name : #PhanideBrowserModel,
	#superclass : #ComposableModel,
	#instVars : [
		'leftTabs',
		'bottomTabs',
		'mainTabs',
		'componentDictionary',
		'baseDirectory'
	],
	#category : 'Phanide-Browser-UI'
}

{ #category : #specs }
PhanideBrowserModel class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :centerRow |
			centerRow
				newColumn: [ :column  |
					column add: #leftTabs
				] left: 0.0 right: 0.75;
				addSplitter;
				newColumn: [ :column |
					column
						newRow: [:row | row add: #mainTabs] top: 0.0 bottom: 0.25;
						addSplitter;
						newRow: [:row | row add: #bottomTabs] top: 0.75 bottom: 0.0
				] left: 0.0 right: 0.25
		];
		yourself
]

{ #category : #'instance creation' }
PhanideBrowserModel class >> directory: aDirectory [
	^ self newWithDirectory: aDirectory
]

{ #category : #'instance creation' }
PhanideBrowserModel class >> new [
	^ self newWithDirectory: '.'
]

{ #category : #'instance creation' }
PhanideBrowserModel class >> newWithDirectory: aDirectory [
	^ self basicNew initializeWithDirectory: aDirectory
]

{ #category : #accessing }
PhanideBrowserModel >> baseDirectory [
	^ baseDirectory
]

{ #category : #accessing }
PhanideBrowserModel >> bottomTabs [
	^ bottomTabs
]

{ #category : #'named components' }
PhanideBrowserModel >> component: component renamedFrom: oldName into: newName [
	oldName = newName ifTrue: [ ^ self ].
	
	componentDictionary at: oldName ifPresent: [ 
		componentDictionary removeKey: oldName.
		componentDictionary at: newName put: component
	]
]

{ #category : #api }
PhanideBrowserModel >> extent [
	^ 1024@768
]

{ #category : #initialization }
PhanideBrowserModel >> initializeWidgets [
	componentDictionary := Dictionary new.
	leftTabs := self newTabManager.
	bottomTabs := self newTabManager.
	mainTabs := self newTabManager.
	self populateComponents
]

{ #category : #initialization }
PhanideBrowserModel >> initializeWithDirectory: aDirectory [
	baseDirectory := aDirectory asFileReference asAbsolute.
	self assert: baseDirectory isDirectory.
	self initialize
]

{ #category : #'named components' }
PhanideBrowserModel >> installComponentModel: aComponentModel [
	| anchorHolder |
	self registerNamedComponent: aComponentModel.

	anchorHolder := self perform: aComponentModel installLocation.
	anchorHolder installPhanideComponentPresenter: aComponentModel

]

{ #category : #accessing }
PhanideBrowserModel >> leftTabs [
	^ leftTabs
]

{ #category : #accessing }
PhanideBrowserModel >> mainTabs [
	^ mainTabs
]

{ #category : #files }
PhanideBrowserModel >> makeTemporaryEditorPermanent: tempEditor [
	tempEditor
		name: tempEditor fileReference printString;
		temporaryEditor: false;
		makeActive.
	^ self

]

{ #category : #files }
PhanideBrowserModel >> openFileView: aFileReference [
	| editor |
	aFileReference isFile ifFalse: [ ^ self ].
	componentDictionary at: self temporaryFileEditorName ifPresent: [ :tempEditor |
		tempEditor fileReference = aFileReference ifTrue: [
			^ self makeTemporaryEditorPermanent: tempEditor
		].
	].

	componentDictionary at: aFileReference printString ifPresent: [ :existentEditor |
		existentEditor makeActive.
		^ self
	].
	
	editor := (PhanideBrowserFileEditor editorForFile: aFileReference) for: self.
	editor
		fileReference: aFileReference;
		name: aFileReference printString.
	self installComponentModel: editor.
	editor makeActive
]

{ #category : #files }
PhanideBrowserModel >> openFileViewTemporarily: aFileReference [
	| editor |
	aFileReference isFile ifFalse: [ ^ self ].
	
	"Make active the existent file"
	componentDictionary at: aFileReference printString ifPresent: [ :existentEditor |
		existentEditor makeActive.
		^ self
	].

	"Check the existent temporary file editor"
	componentDictionary at: self temporaryFileEditorName ifPresent: [ :existentEditor |
		existentEditor fileReference = aFileReference ifTrue: [
			^ existentEditor makeActive
		] ifFalse: [
			existentEditor destroyBrowserComponent
		]
	].

	editor := (PhanideBrowserFileEditor editorForFile: aFileReference) for: self.
	editor
		temporaryEditor: true;
		fileReference: aFileReference;
		name: self temporaryFileEditorName.
	self installComponentModel: editor.
	editor makeActive
]

{ #category : #'as yet unclassified' }
PhanideBrowserModel >> populateComponent: aComponentClass [
	| componentModel |

	"Create the component model"
	componentModel := aComponentClass for: self.
	self installComponentModel: componentModel

]

{ #category : #'as yet unclassified' }
PhanideBrowserModel >> populateComponents [
	PhanideBrowserComponent allSubclassesDo: [ :sc |
		sc isPermanentComponent ifTrue: [ 
			self populateComponent: sc
		]
	]
]

{ #category : #'named components' }
PhanideBrowserModel >> registerNamedComponent: tabModel [
	componentDictionary at: tabModel name
		ifPresent: [ self error: 'Adding clashing Phanide browser component.' ]
		ifAbsentPut: [ tabModel ]
]

{ #category : #removing }
PhanideBrowserModel >> removeClosedComponent: aComponent [
	componentDictionary removeKey: aComponent name.
]

{ #category : #'named components' }
PhanideBrowserModel >> removeComponent: aComponent [
	(componentDictionary includesKey: aComponent name) ifTrue: [
		componentDictionary removeKey: aComponent name
	].
]

{ #category : #files }
PhanideBrowserModel >> temporaryFileEditorName [
	^ #temporaryFileEditor
]

{ #category : #api }
PhanideBrowserModel >> title [
	^ 'Phanide Browser'
]

{ #category : #'as yet unclassified' }
PhanideBrowserModel >> toggleBreakpointInFile: fileReference atLineIndex: lineIndex [
	fileReference ifNil: [ ^ false ].
	"TODO: Notify the debugger about the change."
	^ true
]
