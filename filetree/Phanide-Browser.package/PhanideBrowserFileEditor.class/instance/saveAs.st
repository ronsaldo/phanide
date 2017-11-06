actions
saveAs
	| targetFile |
	targetFile := UIManager default fileSave: 'Save as' extensions: self validFileExtensions path: (fileReference ifNotNil: [fileReference parent fullName]).
	targetFile ifNil: [ ^ nil ].
	
	"Rename myself"
	fileReference := targetFile asAbsolute.
	self name: fileReference printString.
	
	"Save into the target file."
	self saveInto: fileReference.
	^ true