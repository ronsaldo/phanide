"
I represent a file tree
"
Class {
	#name : #PhanideBrowserFileTreeTab,
	#superclass : #PhanideBrowserComponent,
	#instVars : [
		'tree',
		'fileReferenceToNodeDictionary',
		'treeMorph'
	],
	#category : 'Phanide-Browser-UI'
}

{ #category : #specs }
PhanideBrowserFileTreeTab class >> defaultSpec [
	^ self specLayout
		add: #tree
]

{ #category : #menus }
PhanideBrowserFileTreeTab class >> fileTreeDirectoryMenu: aBuilder [
	<contextMenu>
	<fileTreeDirectoryMenu>
	
	(aBuilder item: #'New file')
		keyText: 'n';
		selector: #newFile.
	
	(aBuilder item: #'New directory')
		keyText: 'd';
		selector: #newDirectory;
		withSeparatorAfter.
		
	(aBuilder item: #'Delete directory')
		keyText: 'x';
		selector: #deleteItems
	
]

{ #category : #menus }
PhanideBrowserFileTreeTab class >> fileTreeFileMenu: aBuilder [
	<contextMenu>
	<fileTreeFileMenu>

	(aBuilder item: #'Open file')
		keyText: 'o';
		selector: #openItems.
	(aBuilder item: #'Delete file')
		keyText: 'x';
		selector: #deleteItems
]

{ #category : #menus }
PhanideBrowserFileTreeTab class >> fileTreeFilesMenu: aBuilder [
	<contextMenu>
	<fileTreeFilesMenu>
	
	(aBuilder item: #'Open files')
		keyText: 'o';
		selector: #openItems.
	(aBuilder item: #'Delete files')
		keyText: 'x';
		selector: #deleteItems
]

{ #category : #testing }
PhanideBrowserFileTreeTab class >> isPermanentComponent [
	^ true
]

{ #category : #initialization }
PhanideBrowserFileTreeTab >> childrenFor: fileReference item: item [
	fileReferenceToNodeDictionary at: fileReference put: item.
	fileReference isDirectory ifFalse: [
		^ #()
	] ifTrue: [ 
		^ fileReference children sorted: [ :a :b |
			a isDirectory == b isDirectory ifTrue: [ 
				a basename <= b basename
			] ifFalse: [
				a isDirectory asBit >= b isDirectory asBit
			]
		]
	]
]

{ #category : #accessing }
PhanideBrowserFileTreeTab >> defaultLabel [
	^ 'Files'
]

{ #category : #accessing }
PhanideBrowserFileTreeTab >> defaultName [
	^ #FileTree
]

{ #category : #menus }
PhanideBrowserFileTreeTab >> deleteItems [
	| question selectedFiles |
	question := UIManager default questionWithoutCancel: 'Are you sure that you want to delete permanently the selected files?' title: 'Are you sure?'.
	question ifFalse: [ ^ self ].
	
	selectedFiles := self selectedFiles.
	selectedFiles do: [ :f |
		f exists ifTrue: [
			f isFile ifTrue: [ f delete ] ifFalse: [ f deleteAll ]
		].
	].
	treeMorph dataSource updateData.
	
]

{ #category : #menus }
PhanideBrowserFileTreeTab >> fileTreeMenu: menu shifted: shifted [
	| items file |
	items := tree selectedItems.
	items ifEmpty: [ ^ nil ].
	items size = 1 ifTrue: [
		file := items first content.
		file isDirectory ifTrue: [ 
			menu addTitle: 'Directory'.
			menu addAllFromPragma: 'fileTreeDirectoryMenu' target: self.
		] ifFalse: [
			menu addTitle: 'File'.
			menu addAllFromPragma: 'fileTreeFileMenu' target: self.
		].
	] ifFalse: [ 
		menu addTitle: 'Files'.
		menu addAllFromPragma: 'fileTreeFilesMenu' target: self.
	].

	^ menu
]

{ #category : #initialization }
PhanideBrowserFileTreeTab >> initializePresenter [
	treeMorph onAnnouncement: FTSelectionChanged do: [ :ann |
		self onNewTreeSelection: ann newSelectedRowIndexes
	].

	treeMorph onAnnouncement: FTStrongSelectionChanged do: [ :ann |
		self onDoubleClick: ann selectedRowIndex
	].
]

{ #category : #initialization }
PhanideBrowserFileTreeTab >> initializeWidgets [
 
	| ds |
	fileReferenceToNodeDictionary := Dictionary new.
	ds := PhanideFileTreeDataSource
		roots: {browser baseDirectory}
		children: [ :data :item | self childrenFor: data item: item ].
	ds model: self.
	treeMorph := FTTableMorph new
		dataSource: ds;
		explicitFunction;
		beMultipleSelection.
		
	treeMorph
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	tree := treeMorph asSpecAdapter.
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileTreeTab >> installLocation [
	^ #leftTabs
]

{ #category : #menus }
PhanideBrowserFileTreeTab >> menuForElementIndex: anElementIndex [
	| menu file |
	treeMorph selectedRowIndexes ifEmpty: [ ^ nil ].
	
	menu := MenuMorph new.
	treeMorph selectedRowIndexes size > 1 ifTrue: [		
		menu addAllFromPragma: 'fileTreeFilesMenu' target: self.
	] ifFalse: [ 
		file := (treeMorph dataSource elementAt: anElementIndex) data.
		file isDirectory ifTrue: [ 
			menu addAllFromPragma: 'fileTreeDirectoryMenu' target: self.
		] ifFalse: [
			menu addAllFromPragma: 'fileTreeFileMenu' target: self.
		].
	].

	^ menu
]

{ #category : #'instance creation' }
PhanideBrowserFileTreeTab >> newDirectory [
	| newDirectoryPath |
	newDirectoryPath := self textEntry: 'Enter the path for the new directory.' title: 'New Directory' completeAfter: self selectedFile fullName , FileSystem disk delimiter asString.
	newDirectoryPath ifNil: [ ^ self ].
	
	newDirectoryPath := newDirectoryPath asFileReference.
	newDirectoryPath exists ifTrue: [
		^ UIManager default message: 'Cannot create directory because it already exists.' title: 'Directory Creation Error'. 
	].

	newDirectoryPath createDirectory.
	treeMorph dataSource updateData.
	
]

{ #category : #'instance creation' }
PhanideBrowserFileTreeTab >> newFile [
	| newFilePath |
	newFilePath := self textEntry: 'Enter the path for the new file.' title: 'New File' completeAfter: self selectedFile fullName , FileSystem disk delimiter asString.
	newFilePath ifNil: [ ^ self ].
	
	newFilePath := newFilePath asFileReference.
	newFilePath exists ifTrue: [
		^ UIManager default message: 'Cannot create file because it already exists.' title: 'File Creation Error'. 
	].

	newFilePath writeStreamDo: [ :o | o truncate ].
	treeMorph dataSource updateData.
	browser openFileView: newFilePath
	
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileTreeTab >> onDoubleClick: selectedElement [
	browser openFileView: (treeMorph dataSource elementAt: selectedElement) data
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileTreeTab >> onNewTreeSelection: newSelection [
	newSelection size = 1 ifTrue: [
		browser openFileViewTemporarily: (treeMorph dataSource elementAt: newSelection first) data
	]
]

{ #category : #accessing }
PhanideBrowserFileTreeTab >> selectedFile [
	treeMorph selectedRowIndex = 0 ifTrue: [ ^ nil ].
	^ (treeMorph dataSource elementAt: treeMorph selectedRowIndex) data
]

{ #category : #accessing }
PhanideBrowserFileTreeTab >> selectedFiles [
	| ds |
	ds := treeMorph dataSource.
	^ treeMorph selectedRowIndexes collect: [ :i |
		(ds elementAt: i) data
	]
]

{ #category : #accessing }
PhanideBrowserFileTreeTab >> tree [
	^ tree
]

{ #category : #accessing }
PhanideBrowserFileTreeTab >> treeMorph [
	^ treeMorph
]
