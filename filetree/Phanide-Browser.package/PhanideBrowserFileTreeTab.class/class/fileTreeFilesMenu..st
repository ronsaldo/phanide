menus
fileTreeFilesMenu: aBuilder
	<contextMenu>
	<fileTreeFilesMenu>
	
	(aBuilder item: #'Open files')
		keyText: 'o';
		selector: #openItems.
	(aBuilder item: #'Delete files')
		keyText: 'x';
		selector: #deleteItems