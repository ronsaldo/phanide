menus
fileTreeFileMenu: aBuilder
	<contextMenu>
	<fileTreeFileMenu>

	(aBuilder item: #'Open file')
		keyText: 'o';
		selector: #openItems.
	(aBuilder item: #'Delete file')
		keyText: 'x';
		selector: #deleteItems