instance creation
newFile
	| newFilePath |
	newFilePath := self textEntry: 'Enter the path for the new file.' title: 'New File' completeAfter: self selectedFile fullName , FileSystem disk delimiter asString.
	newFilePath ifNil: [ ^ self ].
	
	newFilePath := newFilePath asFileReference.
	newFilePath exists ifTrue: [
		^ UIManager default message: 'Cannot create file because it already exists.' title: 'File Creation Error'. 
	].

	newFilePath writeStreamDo: [ :o | o truncate ].
	treeMorph dataSource updateData.
	browser openFileView: newFilePath
	