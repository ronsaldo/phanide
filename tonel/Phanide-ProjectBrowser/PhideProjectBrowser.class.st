Class {
	#name : #PhideProjectBrowser,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'menu',
		'toolbar',
		'leftTabs',
		'contentTabs',
		'bottomTabs',
		'rightTopTabs',
		'rightCenterTabs',
		'rightBottomTabs',
		'statusBar',
		'browserComponents',
		'activeTemporaryEditor'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowser class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #menu withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add: #toolbar withConstraints: [ :constraints | constraints height: self toolbarHeight ];
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

{ #category : #adding }
PhideProjectBrowser >> addBrowserComponent: browserComponent inLocation: installLocation [
	^ self addBrowserComponent: browserComponent inLocation: installLocation makeActive: false
]

{ #category : #adding }
PhideProjectBrowser >> addBrowserComponent: browserComponent inLocation: installLocation makeActive: makeActive [
	| installLocationWidget page |
	installLocationWidget := self perform: installLocation.
	page := SpNotebookPage title: browserComponent title provider: [browserComponent].
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

{ #category : #initialization }
PhideProjectBrowser >> initializePresenters [
	menu := self mainMenu.
	toolbar := self mainToolbar.
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
						name: 'File'
				];
				addItem: [ :item |
					item
						name: 'Edit'
				]
		];
		yourself
]

{ #category : #initialization }
PhideProjectBrowser >> mainToolbar [
	^ self newToolbar
		yourself
]

{ #category : #accessing }
PhideProjectBrowser >> menu [
	^ menu
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

{ #category : #accessing }
PhideProjectBrowser >> toolbar [
	^ toolbar
]
