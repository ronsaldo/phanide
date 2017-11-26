as yet unclassified
onNewTreeSelection: newSelection
	newSelection size = 1 ifTrue: [
		browser openFileViewTemporarily: (treeMorph dataSource elementAt: newSelection first) data
	]