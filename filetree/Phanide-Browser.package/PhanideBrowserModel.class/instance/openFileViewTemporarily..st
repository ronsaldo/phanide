files
openFileViewTemporarily: aFileReference
	| editor |
	aFileReference isFile ifFalse: [ ^ self ].
	
	"Make active the existent file"
	componentDictionary at: aFileReference printString ifPresent: [ :existentEditor |
		existentEditor makeActive.
		^ self
	].

	"Check the existent temporary file editor"
	componentDictionary at: self temporaryFileEditorName ifPresent: [ :existentEditor |
		existentEditor fileReference = aFileReference ifTrue: [
			^ existentEditor makeActive
		] ifFalse: [
			existentEditor destroyBrowserComponent
		]
	].

	editor := (PhanideBrowserFileEditor editorForFile: aFileReference) for: self.
	editor
		temporaryEditor: true;
		fileReference: aFileReference;
		name: self temporaryFileEditorName.
	self installComponentModel: editor.
	editor makeActive