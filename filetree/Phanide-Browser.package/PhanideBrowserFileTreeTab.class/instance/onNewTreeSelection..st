as yet unclassified
onNewTreeSelection: newSelection
	newSelection size = 1 ifTrue: [
		browser openFileViewTemporarily: newSelection first
	]