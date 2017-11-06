actions
saveInto: targetFileReference
	| fileContent |
	fileContent := morph getText asString withUnixLineEndings.
	targetFileReference ensureDelete; 
		writeStreamDo: [ :s | s nextPutAll: fileContent ].
