Class {
	#name : #PhideProjectBrowserProjectTreeComponent,
	#superclass : #PhideProjectBrowserComponent,
	#instVars : [
		'treeView'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #specs }
PhideProjectBrowserProjectTreeComponent class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #treeView;
		yourself
]

{ #category : #testing }
PhideProjectBrowserProjectTreeComponent class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhideProjectBrowserProjectTreeComponent >> initializePresenters [
	treeView := self newTreeTable.
	treeView
		addColumn: (SpCompositeTableColumn new
			title: 'Element';
			addColumn: (((SpImageTableColumn evaluated: [ :node | node iconName ifNotNil: [ :name | self iconNamed: name ] ])
						width: 20;
						yourself));
			addColumn: (SpStringTableColumn evaluated: [ :node | node name ]);
			yourself
		);
		hideColumnHeaders;
		children: [ :node | node children ];
		contextMenu: [ self treeViewMenu ];
		whenSelectionChangedDo: [ :selection | self treeViewItemSelected: selection selectedItem ];
		whenActivatedDo: [ :selection | self treeViewItemActivated: selection selectedItem ]
	
]

{ #category : #accessing }
PhideProjectBrowserProjectTreeComponent >> installLocation [
	^ #leftTabs
]

{ #category : #initialization }
PhideProjectBrowserProjectTreeComponent >> loadTopLevelElements [
	treeView roots: self model topLevelElements

]

{ #category : #initialization }
PhideProjectBrowserProjectTreeComponent >> modelChanged [
	| project |
	project := self model ifNil: [^self].
	self loadTopLevelElements.
	project whenTopLevelElementsChangedDo: [ self loadTopLevelElements ].
]

{ #category : #accessing }
PhideProjectBrowserProjectTreeComponent >> title [
	^ 'Project'
]

{ #category : #accessing }
PhideProjectBrowserProjectTreeComponent >> treeView [
	^ treeView
]

{ #category : #initialization }
PhideProjectBrowserProjectTreeComponent >> treeViewItemActivated: selectedItem [
	selectedItem ifNil: [ ^ self ].
	selectedItem openEditorOn: projectBrowser.
]

{ #category : #initialization }
PhideProjectBrowserProjectTreeComponent >> treeViewItemSelected: selectedItem [
	selectedItem ifNil: [ ^ self ].
	selectedItem openTemporaryEditorOn: projectBrowser.
]

{ #category : #initialization }
PhideProjectBrowserProjectTreeComponent >> treeViewMenu [
	| presenter |
	presenter := SpMenuPresenter new.
	treeView selectedItem ifNotNil: [ :selectedItem |
		selectedItem buildProjectTree: self menuOnPresenter: presenter
	].

	^ presenter
]
