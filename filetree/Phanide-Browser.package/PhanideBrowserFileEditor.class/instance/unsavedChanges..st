accessing
unsavedChanges: aBoolean
	unsavedChanges == aBoolean ifTrue: [ ^ self ].
	unsavedChanges := aBoolean.
	self updateLabel