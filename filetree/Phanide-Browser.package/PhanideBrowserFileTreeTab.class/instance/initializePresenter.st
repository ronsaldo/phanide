initialization
initializePresenter
	treeMorph onAnnouncement: FTSelectionChanged do: [ :ann |
		self onNewTreeSelection: ann newSelectedRowIndexes
	].

	treeMorph onAnnouncement: FTStrongSelectionChanged do: [ :ann |
		self onDoubleClick: ann selectedRowIndex
	].