initialization
initializeWidgets
	componentDictionary := Dictionary new.
	leftTabs := self newTabManager.
	bottomTabs := self newTabManager.
	mainTabs := self newTabManager.
	self populateComponents