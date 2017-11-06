actions
save
	fileReference ifNil: [ ^ self saveAs ].
	self saveInto: fileReference.
	self unsavedChanges: false.
	^ true