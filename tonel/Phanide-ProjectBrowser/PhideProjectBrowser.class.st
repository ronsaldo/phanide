Class {
	#name : #PhideProjectBrowser,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'menu',
		'mainToolbar',
		'debugToolbar',
		'leftTabs',
		'contentTabs',
		'bottomTabs',
		'rightTopTabs',
		'rightCenterTabs',
		'rightBottomTabs',
		'statusBar',
		'browserComponents',
		'activeTemporaryEditor',
		'buildToolbar',
		'activePlatformDropList',
		'activeBuildModeDropList',
		'activeLaunchProgramDropList'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowser class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #menu withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add: (SpBoxLayout newHorizontal
			add: #mainToolbar;
			add: #buildToolbar;
			add: #debugToolbar;
			yourself
		) withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add:
			(SpPanedLayout newHorizontal
				position: 20 percent;
				add: #leftTabs;
				add: (SpPanedLayout newHorizontal
					position: 80 percent;
					add: (SpPanedLayout newVertical
						position: 75 percent;
						add: #contentTabs;
						add: #bottomTabs;
						yourself);
					add: (SpPanedLayout newVertical
						position: 1/3;
						add: #rightTopTabs;
						add: (SpPanedLayout newVertical
							position: 50 percent;
							add: #rightCenterTabs;
							add: #rightBottomTabs;
							yourself);
						yourself);
				yourself)
				yourself);
		add: #statusBar withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		yourself
]

{ #category : #commands }
PhideProjectBrowser >> actionAbout [
	self inform: 'TODO: Help About'.
]

{ #category : #commands }
PhideProjectBrowser >> actionBuildAll [
	self model actionBuildAll
]

{ #category : #commands }
PhideProjectBrowser >> actionCleanAll [
	self model actionCleanAll
]

{ #category : #commands }
PhideProjectBrowser >> actionConfigureBuild [
	self model actionConfigureBuild
]

{ #category : #commands }
PhideProjectBrowser >> actionCopy [
	self inform: 'TODO: Copy'.
]

{ #category : #commands }
PhideProjectBrowser >> actionCut [
	self inform: 'TODO: Cut'.
]

{ #category : #commands }
PhideProjectBrowser >> actionDebugContinue [
	self inform: 'TODO: debug continue'.
]

{ #category : #commands }
PhideProjectBrowser >> actionDebugPause [
	self inform: 'TODO: debug pause'.
]

{ #category : #commands }
PhideProjectBrowser >> actionDebugRun [
	self inform: 'TODO: debug run'.
]

{ #category : #commands }
PhideProjectBrowser >> actionDebugStepInto [
	self inform: 'TODO: debug step into'.
]

{ #category : #commands }
PhideProjectBrowser >> actionDebugStepOver [
	self inform: 'TODO: debug step over'.
]

{ #category : #commands }
PhideProjectBrowser >> actionDebugStop [
	self inform: 'TODO: debug stop'.
]

{ #category : #commands }
PhideProjectBrowser >> actionExit [
	self application close
]

{ #category : #commands }
PhideProjectBrowser >> actionInstallBuild [
	self model actionInstallBuild
]

{ #category : #commands }
PhideProjectBrowser >> actionOpenFile [
	self inform: 'TODO: open file'.
]

{ #category : #commands }
PhideProjectBrowser >> actionOpenFolder [
	self inform: 'TODO: open folder'.
]

{ #category : #commands }
PhideProjectBrowser >> actionPaste [
	self inform: 'TODO: Paste'.
]

{ #category : #commands }
PhideProjectBrowser >> actionRebuildAll [
	self model actionRebuildAll
]

{ #category : #commands }
PhideProjectBrowser >> actionRedo [
	self inform: 'TODO: Redo'.
]

{ #category : #commands }
PhideProjectBrowser >> actionRunWithoutDebugging [
	^ self model actionRunWithoutDebugging
]

{ #category : #commands }
PhideProjectBrowser >> actionSaveFile [
	self inform: 'TODO: save file'.
]

{ #category : #commands }
PhideProjectBrowser >> actionSaveFileAs [
	self inform: 'TODO: save file as'.
]

{ #category : #commands }
PhideProjectBrowser >> actionUndo [
	self inform: 'TODO: Undo'.
]

{ #category : #interactions }
PhideProjectBrowser >> activeBuildModeChanged [
	| activeBuildPlatform newBuildModes newActiveBuildMode |

	activeBuildPlatform := self model activeBuildPlatform.
	activeBuildPlatform ifNil: [
		activeBuildModeDropList items: #().
		^ self
	].

	newBuildModes := activeBuildPlatform buildModes values sort: [:a :b | a name < b name].
	activeBuildModeDropList items: newBuildModes.

	newActiveBuildMode := self model activeBuildPlatform.
	(newActiveBuildMode isNil or: [ newBuildModes includes: newActiveBuildMode ]) ifTrue: [
		activeBuildModeDropList selectItem: newActiveBuildMode
	].

	self activeLaunchProgramChanged.
	
]

{ #category : #interactions }
PhideProjectBrowser >> activeBuildPlatformChanged [
	| newActivePlatform newBuildPlatforms |

	newBuildPlatforms := self model buildPlatforms values sort: [:a :b | a name < b name].
	activePlatformDropList items: newBuildPlatforms.

	newActivePlatform := self model activeBuildPlatform.
	(newActivePlatform isNil or: [ newBuildPlatforms includes: newActivePlatform ]) ifTrue: [
		activePlatformDropList selectItem: newActivePlatform
	].
	
	self activeBuildModeChanged

]

{ #category : #interactions }
PhideProjectBrowser >> activeLaunchProgramChanged [
	| activeBuildMode newLaunchSettings newActiveLaunchProgram |

	activeBuildMode := self model activeBuildMode.
	activeBuildMode ifNil: [
		activeLaunchProgramDropList items: #().
		^ self
	].

	newLaunchSettings := activeBuildMode launchSettings values sort: [:a :b | a name < b name].
	activeLaunchProgramDropList items: newLaunchSettings.

	newActiveLaunchProgram := self model activeLaunchProgram.
	(newActiveLaunchProgram isNil or: [ newLaunchSettings includes: newActiveLaunchProgram ]) ifTrue: [
		activeLaunchProgramDropList selectItem: newActiveLaunchProgram
	].

]

{ #category : #adding }
PhideProjectBrowser >> addBrowserComponent: browserComponent inLocation: installLocation [
	^ self addBrowserComponent: browserComponent inLocation: installLocation makeActive: false
]

{ #category : #adding }
PhideProjectBrowser >> addBrowserComponent: browserComponent inLocation: installLocation makeActive: makeActive [
	| installLocationWidget page |
	installLocationWidget := self perform: installLocation.
	page := PhideProjectBrowserNotebookPage title: browserComponent title provider: [browserComponent].
	page
		projectBrowser: self;
		browserComponent: browserComponent;
		yourself.
	browserComponent projectBrowser: self; projectBrowserAnchor: page.
	browserComponent isCloseable ifTrue: [ page beCloseable ].

	installLocationWidget addPage: page.
	browserComponent browserComponentKey ifNotNil: [ :key |
		self browserComponents at: key put: browserComponent
	].

	makeActive ifTrue: [
		installLocationWidget selectPage: page
	]
]

{ #category : #accessing }
PhideProjectBrowser >> bottomTabs [
	^ bottomTabs
]

{ #category : #accessing }
PhideProjectBrowser >> browserComponents [
	^ browserComponents ifNil: [ browserComponents := Dictionary new ]
]

{ #category : #initialization }
PhideProjectBrowser >> buildBuildToolbar [
	^ self newToolbar
		addItem: (activePlatformDropList := SpDropListPresenter new
			display: [ :element | element name ];
			yourself);
		addItem: (activeBuildModeDropList := SpDropListPresenter new
			display: [ :element | element name ];
			yourself);
		yourself
]

{ #category : #initialization }
PhideProjectBrowser >> buildDebugToolbar [	
	^ self newToolbar
		addItem: (activeLaunchProgramDropList := SpDropListPresenter new
			display: [ :element | element name ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #smallDoIt);
			help: 'Run';
			action: [ self actionDebugRun ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #stop);
			help: 'Stop';
			action: [ self actionDebugStop ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #glamorousGo);
			help: 'Continue';
			action: [ self actionDebugContinue ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			label: 'Pause';
			help: 'Pause';
			action: [ self actionDebugPause ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #glamorousInto);
			label: 'Into';
			help: 'Step into. Gdb step';
			action: [ self actionDebugStepInto ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #glamorousOver);
			label: 'Over';
			help: 'Step over. Gdb next';
			action: [ self actionDebugStepOver ];
			yourself);
		yourself
]

{ #category : #initialization }
PhideProjectBrowser >> buildMainToolbar [
	^ self newToolbar
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #smallSaveIcon);
			help: 'Save file';
			action: [ self actionSaveFile ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #smallSaveAsIcon);
			help: 'Save file as...';
			action: [ self actionSaveFileAs ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #smallOpenIcon);
			help: 'Open...';
			action: [ self actionOpenFile ];
			yourself);

		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #smallUndoIcon);
			help: 'Undo';
			action: [ self actionUndo ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #smallRedoIcon);
			help: 'Redo';
			action: [ self actionRedo ];
			yourself);

		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #smallCutIcon);
			help: 'Cut';
			action: [ self actionCut ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #smallCopyIcon);
			help: 'Copy';
			action: [ self actionCopy ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			icon: (self iconNamed: #smallPasteIcon);
			help: 'Paste';
			action: [ self actionPaste ];
			yourself);
		yourself
]

{ #category : #menu }
PhideProjectBrowser >> buildMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Configure Build';
						action: [ self actionConfigureBuild ].
				];
				addItem: [ :item |
					item
						name: 'Build All';
						action: [ self actionBuildAll ].
				];
				addItem: [ :item |
					item
						name: 'Install All';
						action: [ self actionInstallBuild ].
				];
				addItem: [ :item |
					item
						name: 'Rebuild All';
						action: [ self actionRebuildAll ].
				];
				addItem: [ :item |
					item
						name: 'Clean All';
						action: [ self actionCleanAll ].
				]
		];
		yourself
]

{ #category : #accessing }
PhideProjectBrowser >> buildToolbar [
	^ buildToolbar
]

{ #category : #events }
PhideProjectBrowser >> componentClosed: aComponent [
	self browserComponents removeKey: aComponent browserComponentKey ifAbsent: [  ].
	activeTemporaryEditor == aComponent ifTrue: [
		activeTemporaryEditor := nil
	].
]

{ #category : #accessing }
PhideProjectBrowser >> contentTabs [
	^ contentTabs
]

{ #category : #initialization }
PhideProjectBrowser >> createBrowserPermanentComponents [
	PhideProjectBrowserComponent withAllSubclassesDo: [ :each |
		each isPermanentComponent ifTrue: [
			(each on: self model)
				browserComponentKey: each;
				addToProjectBrowser: self
		]
	]
]

{ #category : #menu }
PhideProjectBrowser >> debugMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Run';
						icon: (self iconNamed: #smallDoIt);
						action: [ self actionDebugRun ].
				];
				addItem: [ :item |
					item
						name: 'Run without debugging';
						icon: (self iconNamed: #smallDoIt);
						action: [ self actionRunWithoutDebugging ].
				];
				addItem: [ :item |
					item
						name: 'Stop';
						icon: (self iconNamed: #stop);
						action: [ self actionDebugStop ].
				]
		];
		yourself
]

{ #category : #accessing }
PhideProjectBrowser >> debugToolbar [
	^ debugToolbar
]

{ #category : #menu }
PhideProjectBrowser >> editMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Undo';
						icon: (self iconNamed: #smallUndoIcon);
						action: [ self actionUndo ].
				];
				addItem: [ :item |
					item
						name: 'Redo';
						icon: (self iconNamed: #smallRedoIcon);
						action: [ self actionRedo ].
				]
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
		];
		yourself
]

{ #category : #menu }
PhideProjectBrowser >> fileMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Open File...';
						icon: (self iconNamed: #openIcon);
						action: [ self actionOpenFile ].
				];
				addItem: [ :item |
					item
						name: 'Open Folder...';
						icon: (self iconNamed: #openIcon);
						action: [ self actionOpenFolder ].
				];
				addItem: [ :item |
					item
						name: 'Save';
						icon: (self iconNamed: #smallSaveIcon);
						action: [ self actionSaveFile ].
				];
				addItem: [ :item |
					item
						name: 'Save As...';
						icon: (self iconNamed: #smallSaveAsIcon);
						action: [ self actionSaveFileAs ].
				]
		];
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Exit';
						action: [ self actionExit ].
				]
		];
		yourself
]

{ #category : #menu }
PhideProjectBrowser >> helpMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'About...';
						action: [ self actionAbout ].
				]
		];
		yourself
]

{ #category : #initialization }
PhideProjectBrowser >> initializePresenters [
	menu := self mainMenu.
	mainToolbar := self buildMainToolbar.
	buildToolbar := self buildBuildToolbar.
	debugToolbar := self buildDebugToolbar.
	leftTabs := self newNotebook.
	contentTabs := self newNotebook.
	bottomTabs := self newNotebook.
	rightTopTabs := self newNotebook.
	rightCenterTabs := self newNotebook.
	rightBottomTabs := self newNotebook.
	statusBar := self newStatusBar.
	self createBrowserPermanentComponents.
]

{ #category : #initialization }
PhideProjectBrowser >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 1024@768
]

{ #category : #accessing }
PhideProjectBrowser >> leftTabs [
	^ leftTabs
]

{ #category : #initialization }
PhideProjectBrowser >> mainMenu [
	^ self newMenuBar
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'File';
						subMenu: self fileMenu
				];
				addItem: [ :item |
					item
						name: 'Edit';
						subMenu: self editMenu
				];
				addItem: [ :item |
					item
						name: 'Build';
						subMenu: self buildMenu
				];
				addItem: [ :item |
					item
						name: 'Debug';
						subMenu: self debugMenu
				];
				addItem: [ :item |
					item
						name: 'View';
						subMenu: self viewMenu
				];
				addItem: [ :item |
					item
						name: 'Help';
						subMenu: self helpMenu
				]
		];
		yourself
]

{ #category : #accessing }
PhideProjectBrowser >> mainToolbar [
	^ mainToolbar
]

{ #category : #accessing }
PhideProjectBrowser >> menu [
	^ menu
]

{ #category : #interactions }
PhideProjectBrowser >> modelChanged [
	| project |
	super modelChanged.
	project := self model ifNil: [ ^ self ].

	project
		whenBuildPlatformsChangedDo: [ self activeBuildPlatformChanged ];
		whenActiveBuildPlatformChangedDo: [ self activeBuildPlatformChanged ];
		whenActiveBuildModeChangedDo: [ self activeBuildModeChanged ];
		whenActiveLaunchProgramChangedDo: [ self activeLaunchProgramChanged ].
	self activeBuildPlatformChanged.
	
		
]

{ #category : #commands }
PhideProjectBrowser >> openFileEditorFor: aFileProjectElement [
	self browserComponents at: aFileProjectElement ifPresent: [ :existent |
		existent makeNonTemporaryEditor.
		^ self
	].

	self openNewFileEditorFor: aFileProjectElement temporary: false.
]

{ #category : #commands }
PhideProjectBrowser >> openFileTemporaryEditorFor: aFileProjectElement [
	self browserComponents at: aFileProjectElement ifPresent: [ ^ self ].
	self openNewFileEditorFor: aFileProjectElement temporary: true.
]

{ #category : #commands }
PhideProjectBrowser >> openNewFileEditorFor: aFileProjectElement temporary: isTemporary [
	| editorClass editor |
	editorClass := PhideProjectBrowserFileEditorComponent editorForFile: aFileProjectElement fileReference.
	editorClass ifNil: [ ^ nil ].
	
	editor := editorClass on: aFileProjectElement.
	editor browserComponentKey: aFileProjectElement.
	isTemporary ifTrue: [ 
		editor isTemporary: isTemporary.
		activeTemporaryEditor ifNotNil: [ activeTemporaryEditor close ].
		self assert: activeTemporaryEditor isNil.
		activeTemporaryEditor := editor.
	].

	editor addToProjectBrowser: self makeActive: true
]

{ #category : #accessing }
PhideProjectBrowser >> rightBottomTabs [
	^ rightBottomTabs
]

{ #category : #accessing }
PhideProjectBrowser >> rightCenterTabs [
	^ rightCenterTabs
]

{ #category : #accessing }
PhideProjectBrowser >> rightTopTabs [
	^ rightTopTabs
]

{ #category : #accessing }
PhideProjectBrowser >> statusBar [
	^ statusBar
]

{ #category : #events }
PhideProjectBrowser >> temporaryEditorIsNoTemporaryAnymore: anEditor [
	activeTemporaryEditor == anEditor ifTrue: [
		activeTemporaryEditor := nil
	]
]

{ #category : #menu }
PhideProjectBrowser >> viewMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Toolbar';
						action: [ ].
				]
		];
		yourself
]
