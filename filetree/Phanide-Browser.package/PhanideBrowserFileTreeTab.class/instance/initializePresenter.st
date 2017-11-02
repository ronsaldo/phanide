initialization
initializePresenter
	| oldSelection newSelection |
	tree doubleClick: [
		self onDoubleClick: tree selectedItems
	].

	oldSelection := #().
	tree whenSelectedItemsChanged: [:selectedElements |
		newSelection := selectedElements asArray.
		newSelection ~= oldSelection ifTrue: [ 
			self onNewTreeSelection: newSelection.
		].
		oldSelection := newSelection
	]