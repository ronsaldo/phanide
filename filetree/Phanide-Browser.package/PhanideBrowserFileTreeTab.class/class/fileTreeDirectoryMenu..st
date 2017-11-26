menus
fileTreeDirectoryMenu: aBuilder
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
	