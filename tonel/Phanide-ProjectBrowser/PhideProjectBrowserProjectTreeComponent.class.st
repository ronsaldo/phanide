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
PhideProjectBrowserProjectTreeComponent >> connectPresenters [
	treeView roots: self model topLevelElements.
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
		whenSelectionChangedDo: [ :selection | self treeViewItemSelected: selection selectedItem ];
		whenActivatedDo: [ :selection | self treeViewItemActivated: selection selectedItem ]
	
]

{ #category : #accessing }
PhideProjectBrowserProjectTreeComponent >> installLocation [
	^ #leftTabs
]

{ #category : #TOREMOVE }
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
