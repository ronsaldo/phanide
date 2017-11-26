menus
fileTreeMenu: menu shifted: shifted
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