initialization
initializeWithDirectory: aDirectory
	baseDirectory := aDirectory asFileReference asAbsolute.
	self assert: baseDirectory isDirectory.
	self initialize