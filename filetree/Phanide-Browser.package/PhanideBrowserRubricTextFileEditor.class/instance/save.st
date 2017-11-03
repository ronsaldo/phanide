actions
save
	| fileContent |
	fileContent := morph getText asString withUnixLineEndings.
	fileReference ensureDelete; 
		writeStreamDo: [ :s | s nextPutAll: fileContent ]