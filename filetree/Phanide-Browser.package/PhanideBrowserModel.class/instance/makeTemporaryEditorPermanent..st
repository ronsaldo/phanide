files
makeTemporaryEditorPermanent: tempEditor
	tempEditor
		name: tempEditor fileReference printString;
		temporaryEditor: false;
		makeActive.
	^ self
