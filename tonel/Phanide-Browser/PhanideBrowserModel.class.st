"
I am the main Phanide browser UI.
"
Class {
	#name : #PhanideBrowserModel,
	#superclass : #ComposablePresenter,
	#instVars : [
		'leftTabs',
		'bottomTabs',
		'mainTabs',
		'componentDictionary',
		'baseDirectory',
		'debuggerState',
		'mainStatusBar',
		'mainMenuBar',
		'mainToolBar',
		'startupProgramCombo',
		'debugToolBar',
		'rightTopTabs',
		'rightBottomTabs',
		'rightMiddleTabs'
	],
	#category : #'Phanide-Browser-UI'
}

{ #category : #specs }
PhanideBrowserModel class >> defaultSpec [
	^ SpecLayout composed
		newColumn: [ :mainColumn |
			mainColumn add: #mainMenuBar height: self toolbarHeight.
			mainColumn newRow: [ :toolbarRow |
				toolbarRow add: #mainToolBar.
				toolbarRow add: #startupProgramCombo width: 200.
				toolbarRow add: #debugToolBar.
			] height: self toolbarHeight.
			mainColumn newRow: [ :centerRow |
				centerRow
					newColumn: [ :column  |
						column add: #leftTabs
					] left: 0.0 right: 0.8;
					addSplitter;
					newColumn: [ :column |
						column
							newRow: [:row | row add: #mainTabs] top: 0.0 bottom: 0.25;
							addSplitter;
							newRow: [:row | row add: #bottomTabs] top: 0.75 bottom: 0.0
					] left: 0.0 right: 0.4;
					addSplitter;
					newColumn: [ :column  |
						column
							newRow: [:row | row add: #rightTopTabs] top: 0.0 bottom: 2.0/3.0;
							addSplitter;
							newRow: [:row | row add: #rightMiddleTabs] top: 1.0/3.0 bottom: 1.0/3.0;
							addSplitter;
							newRow: [:row | row add: #rightBottomTabs] top: 2.0/3.0 bottom: 0.0
					]
			].
			mainColumn add: #mainStatusBar height: self toolbarHeight.
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

{ #category : #'main actions' }
PhanideBrowserModel >> actionAbout [
	self inform: 'TODO: actionAbout'
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionCopy [
	self inform: 'TODO: actionCopy'
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionCut [
	self inform: 'TODO: actionCut'
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionDebugContinue [
	self debuggerState continueCurrentProgramExecution
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionDebugPause [
	self debuggerState pauseCurrentProgramExecution
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionDebugRun [
	self debuggerState runStartupProgramWithDebugger
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionDebugStepInto [
	self debuggerState stepInto
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionDebugStepOver [
	self debuggerState stepOver
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionDebugStop [
	self debuggerState stopCurrentDebugger
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionExit [
	self delete
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionOpenFile [
	self inform: 'TODO: actionOpenFile'
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionOpenFolder [
	self inform: 'TODO: actionOpenFolder'
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionPaste [
	self inform: 'TODO: actionPaste'
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionRedo [
	self inform: 'TODO: actionRedo'
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionRunWithoutDebugging [
	self inform: 'TODO: actionRunWithoutDebugging'
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionSaveFile [
	self inform: 'TODO: actionSaveFile'
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionSaveFileAs [
	self inform: 'TODO: actionSaveFileAs'
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionToggleToolbarVisibility [
	self inform: 'TODO: actionToggleToolbarVisibility'
]

{ #category : #'main actions' }
PhanideBrowserModel >> actionUndo [
	self inform: 'TODO: actionUndo'
]

{ #category : #enumerating }
PhanideBrowserModel >> allComponentsDo: aBlock [
	componentDictionary valuesDo: aBlock
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

{ #category : #initialization }
PhanideBrowserModel >> createDebugMenu [
	^ MenuPresenter new
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Run';
					icon: (self iconNamed: #smallDoIt);
					action: [ self actionDebugRun ]
			].
			group addItem: [ :item |
				item
					name: 'Run without debugging';
					action: [ self actionRunWithoutDebugging ]
			].
			group addItem: [ :item |
				item
					name: 'Stop';
					icon: (self iconNamed: #stop);
					action: [ self actionDebugStop ]
			].
		]
]

{ #category : #initialization }
PhanideBrowserModel >> createDebugToolBar [
	^ MenuPresenter new
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Run';
					description: 'Run selected startup program with a debugger.';
					icon: (self iconNamed: #smallDoIt);
					action: [ self actionDebugRun ]
			].
			group addItem: [ :item |
				item
					name: 'Stop';
					description: 'Stops the currently program that is being executed.';
					icon: (self iconNamed: #stop);
					action: [ self actionDebugStop ]
			]
		];
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Continue';
					description: 'Continue';
					icon: (self iconNamed: #glamorousGo);
					action: [ self actionDebugContinue ]
			].
			group addItem: [ :item |
				item
					name: 'Pause';
					description: 'Pause';
					action: [ self actionDebugPause ]
			].
			group addItem: [ :item |
				item
					name: 'Into';
					description: 'Step into. Gdb step';
					icon: (self iconNamed: #glamorousInto);
					action: [ self actionDebugStepInto ]
			].
			group addItem: [ :item |
				item
					name: 'Over';
					description: 'Step over. Gdb next';
					icon: (self iconNamed: #glamorousOver);
					action: [ self actionDebugStepOver ]
			].

		].	
]

{ #category : #initialization }
PhanideBrowserModel >> createEditMenu [
	^ MenuPresenter new
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Undo';
					icon: (self iconNamed: #smallUndoIcon);
					action: [ self actionUndo ]
			].
			group addItem: [ :item |
				item
					name: 'Redo';
					icon: (self iconNamed: #smallRedoIcon);
					action: [ self actionRedo ]
			].
		];
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Cut';
					icon: (self iconNamed: #smallCutIcon);
					action: [ self actionCut ]
			].
			group addItem: [ :item |
				item
					name: 'Copy';
					icon: (self iconNamed: #smallCopyIcon);
					action: [ self actionCopy ]
			].
			group addItem: [ :item |
				item
					name: 'Paste';
					icon: (self iconNamed: #smallPasteIcon);
					action: [ self actionPaste ]
			].

		]
]

{ #category : #initialization }
PhanideBrowserModel >> createFileMenu [
	^ MenuPresenter new
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Open File...';
					icon: (self iconNamed: #smallOpenIcon);
					action: [ self actionOpenFile ]
			].
			group addItem: [ :item |
				item
					name: 'Open Folder...';
					action: [ self actionOpenFolder ]
			].
			group addItem: [ :item |
				item
					name: 'Save file...';
					icon: (self iconNamed: #smallSaveIcon);
					action: [ self actionSaveFile ]
			].
			group addItem: [ :item |
				item
					name: 'Save file as...';
					icon: (self iconNamed: #smallSaveAsIcon);
					action: [ self actionSaveFileAs ]
			].
		];
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Exit';
					action: [ self actionExit ]
			].
		]
]

{ #category : #initialization }
PhanideBrowserModel >> createHelpMenu [
	^ MenuPresenter new
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'About';
					action: [ self actionAbout ]
			].
		]
]

{ #category : #initialization }
PhanideBrowserModel >> createMainMenu [
	^ MenuPresenter new
		addGroup: [ :group |
			group addItem: [ :item |
				item name: 'File'; subMenu: self createFileMenu
			];
			addItem: [ :item |
				item name: 'Edit'; subMenu: self createEditMenu
			];
			addItem: [ :item |
				item name: 'Debug'; subMenu: self createDebugMenu
			];
			addItem: [ :item |
				item name: 'View'; subMenu: self createViewMenu
			];
			addItem: [ :item |
				item name: 'Help'; subMenu: self createHelpMenu
			]
		]
]

{ #category : #initialization }
PhanideBrowserModel >> createMainToolBar [
	^ MenuPresenter new
		addGroup: [ :group |
			group addItem: [ :item |
				item
					description: 'Save file';
					icon: (self iconNamed: #smallSaveIcon);
					action: [ self actionSaveFile ]
			].
			group addItem: [ :item |
				item
					description: 'Save file as';
					icon: (self iconNamed: #smallSaveAsIcon);
					action: [ self actionSaveFileAs ]
			].
			group addItem: [ :item |
				item
					description: 'Open';
					icon: (self iconNamed: #smallOpenIcon);
					action: [ self actionOpenFile ]
			]
		];
		addGroup: [ :group |
			group addItem: [ :item |
				item
					description: 'Undo';
					icon: (self iconNamed: #smallUndoIcon);
					action: [ self actionUndo ]
			].
			group addItem: [ :item |
				item
					description: 'Redo';
					icon: (self iconNamed: #smallRedoIcon);
					action: [ self actionRedo ]
			]
		];
		addGroup: [ :group |
			group addItem: [ :item |
				item
					description: 'Cut';
					icon: (self iconNamed: #smallCutIcon);
					action: [ self actionCut ]
			].
			group addItem: [ :item |
				item
					description: 'Copy';
					icon: (self iconNamed: #smallCopyIcon);
					action: [ self actionCopy ]
			].
			group addItem: [ :item |
				item
					description: 'Paste';
					icon: (self iconNamed: #smallPasteIcon);
					action: [ self actionPaste ]
			]
		].
]

{ #category : #initialization }
PhanideBrowserModel >> createViewMenu [
	^ MenuPresenter new
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Toolbar';
					action: [ self actionToggleToolbarVisibility ]
			].
		]
]

{ #category : #accessing }
PhanideBrowserModel >> debugToolBar [
	^ debugToolBar
]

{ #category : #'as yet unclassified' }
PhanideBrowserModel >> debuggerState [
	^ debuggerState ifNil: [ debuggerState := PhanideBrowserDebuggerState new browser: self]
]

{ #category : #api }
PhanideBrowserModel >> extent [
	^ 1024@768
]

{ #category : #'named components' }
PhanideBrowserModel >> getNamedComponent: componentName [
	^ self getNamedComponent: componentName ifAbsent: [nil]
]

{ #category : #'named components' }
PhanideBrowserModel >> getNamedComponent: componentName ifAbsent: absentBlock [
	^ componentDictionary at: componentName ifAbsent: absentBlock
]

{ #category : #'as yet unclassified' }
PhanideBrowserModel >> getOrCreateBreakpointInFile: fileReference atLineIndex: lineIndex [
	fileReference ifNil: [ ^ nil ].
	^ true

]

{ #category : #initialization }
PhanideBrowserModel >> initializeWidgets [
	componentDictionary := Dictionary new.
	mainMenuBar := self createMainMenu.
	startupProgramCombo := self newDropList.
	mainToolBar := self createMainToolBar.
	debugToolBar := self createDebugToolBar.
	leftTabs := self newTabManager.
	bottomTabs := self newTabManager.
	rightTopTabs := self newTabManager.
	rightMiddleTabs := self newTabManager.
	rightBottomTabs := self newTabManager.
	mainTabs := self newTabManager.
	mainStatusBar := self newLabel.
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
PhanideBrowserModel >> mainMenuBar [
	^ mainMenuBar
]

{ #category : #accessing }
PhanideBrowserModel >> mainStatusBar [
	^ mainStatusBar
]

{ #category : #accessing }
PhanideBrowserModel >> mainTabs [
	^ mainTabs
]

{ #category : #accessing }
PhanideBrowserModel >> mainToolBar [
	^ mainToolBar
]

{ #category : #files }
PhanideBrowserModel >> makeTemporaryEditorPermanent: tempEditor [
	^ tempEditor
		name: tempEditor fileReference printString;
		temporaryEditor: false;
		makeActive
]

{ #category : #files }
PhanideBrowserModel >> openFileView: aFileReference [
	| editor |
	aFileReference isFile ifFalse: [ ^ nil ].
	componentDictionary at: self temporaryFileEditorName ifPresent: [ :tempEditor |
		tempEditor fileReference = aFileReference ifTrue: [
			^ self makeTemporaryEditorPermanent: tempEditor
		].
	].

	componentDictionary at: aFileReference printString ifPresent: [ :existentEditor |
		^ existentEditor makeActive.
	].
	
	editor := (PhanideBrowserFileEditor editorForFile: aFileReference) for: self.
	editor
		fileReference: aFileReference;
		name: aFileReference printString.
	self installComponentModel: editor.
	^ editor makeActive
]

{ #category : #files }
PhanideBrowserModel >> openFileViewTemporarily: aFileReference [
	| editor |
	aFileReference isFile ifFalse: [ ^ nil ].
	
	"Make active the existent file"
	componentDictionary at: aFileReference printString ifPresent: [ :existentEditor |
		^ existentEditor makeActive
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
	^ editor makeActive
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

{ #category : #accessing }
PhanideBrowserModel >> rightBottomTabs [
	^ rightBottomTabs
]

{ #category : #accessing }
PhanideBrowserModel >> rightMiddleTabs [
	^ rightMiddleTabs
]

{ #category : #accessing }
PhanideBrowserModel >> rightTopTabs [
	^ rightTopTabs
]

{ #category : #initialization }
PhanideBrowserModel >> setCurrentStartupProgramForFileReference: aStartupProgramFileReference [
	| programSettings |
	programSettings := self debuggerState setCurrentStartupProgramForFileReference: aStartupProgramFileReference.
	
	startupProgramCombo addItemLabeled: programSettings name do: [
		self debuggerState currentStartupProgram: programSettings
	]
]

{ #category : #accessing }
PhanideBrowserModel >> startupProgramCombo [
	^ startupProgramCombo
]

{ #category : #files }
PhanideBrowserModel >> temporaryFileEditorName [
	^ #temporaryFileEditor
]

{ #category : #api }
PhanideBrowserModel >> title [
	^ 'Phanide Browser'
]
