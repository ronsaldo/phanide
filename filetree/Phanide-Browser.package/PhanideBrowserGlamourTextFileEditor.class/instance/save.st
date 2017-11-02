initialization
save
	self flag: 'TODO: Detect or preserve the correct type of line endings.'.
	fileReference
		ensureDelete; 
		writeStreamDo: [ :s | s nextPutAll: presentation text asString withUnixLineEndings ].
	self unsavedChanges: false.