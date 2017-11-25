as yet unclassified
fileChanged
	self flag: 'Support the different line endings natively'.
	textModel setText: (fileReference contents withSqueakLineEndings ).
	(PhanideStyler forFileReference: fileReference) ifNotNil: [ :styler |
		morph editingMode: (styler rubricEditingModeForFileReference: fileReference browserComponent: self).
		morph hasUnacceptedEdits: false.
	]