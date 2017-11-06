as yet unclassified
fileChanged
	textModel setText: fileReference contents.
	(PhanideStyler forFileReference: fileReference) ifNotNil: [ :styler |
		morph editingMode: (styler rubricEditingModeForFileReference: fileReference browserComponent: self).
		morph hasUnacceptedEdits: false.
	]