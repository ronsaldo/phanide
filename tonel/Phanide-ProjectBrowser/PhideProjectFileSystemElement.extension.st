Extension { #name : #PhideProjectFileSystemElement }

{ #category : #'*Phanide-ProjectBrowser' }
PhideProjectFileSystemElement >> buildProjectTree: projectTree menuOnPresenter: menuPresenter [
	menuPresenter
		addItem: [:item |
			item
				name: 'Rename';
				action: [ self inform: 'TODO: Rename project element' ]
		];
		addItem: [:item |
			item
				name: 'New folder';
				action: [ self inform: 'TODO: create new folder' ]
		];
		addItem: [ :item |
			item
				name: 'Delete';
				action: [ self inform: 'TODO: delete project file system element' ]	
		]
]
