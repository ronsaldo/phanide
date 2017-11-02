files
openFileView: aFileReference
	| editor |
	aFileReference isFile ifFalse: [ ^ self ].
	componentDictionary at: self temporaryFileEditorName ifPresent: [ :tempEditor |
		tempEditor fileReference = aFileReference ifTrue: [
			^ self makeTemporaryEditorPermanent: tempEditor
		].
	].

	componentDictionary at: aFileReference printString ifPresent: [ :existentEditor |
		existentEditor makeActive.
		^ self
	].
	
	editor := (PhanideBrowserFileEditor editorForFile: aFileReference) for: self.
	editor
		fileReference: aFileReference;
		name: aFileReference printString.
	self installComponentModel: editor.
	editor makeActive