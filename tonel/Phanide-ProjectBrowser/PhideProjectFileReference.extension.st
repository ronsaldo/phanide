Extension { #name : #PhideProjectFileReference }

{ #category : #'*Phanide-ProjectBrowser' }
PhideProjectFileReference >> buildProjectTree: projectTree menuOnPresenter: menuPresenter [
	super buildProjectTree: projectTree menuOnPresenter: menuPresenter.
	(fileReference isExecutable or: [#(exe com bat bin elf) includes: fileReference extensions]) ifTrue: [
		menuPresenter addItem: [ :item |
			item
				name: 'Make active launch program';
				action: [ self project activeLaunchProgram: self asValidLaunchProgramSettings ]
		]
	].

	menuPresenter addItem: [ :item |
		item
			name: 'Program launch settings...';
			action: [ self asValidLaunchProgramSettings openSettingsBrowser ]
	].
]

{ #category : #'*Phanide-ProjectBrowser' }
PhideProjectFileReference >> openEditorOn: aProjectBrowser [
	aProjectBrowser openFileEditorFor: self
]

{ #category : #'*Phanide-ProjectBrowser' }
PhideProjectFileReference >> openTemporaryEditorOn: aProjectBrowser [
	aProjectBrowser openFileTemporaryEditorFor: self
]
