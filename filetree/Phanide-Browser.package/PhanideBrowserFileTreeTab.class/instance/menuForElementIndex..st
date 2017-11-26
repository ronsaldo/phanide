menus
menuForElementIndex: anElementIndex
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