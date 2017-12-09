actions
saveInto: targetFileReference
	| fileContent |
	fileContent := morph getText asString withUnixLineEndings.
	targetFileReference writeStreamDo: [ :s |
		s truncate; nextPutAll: fileContent
	].
