instance creation
newDirectory
	| newDirectoryPath |
	newDirectoryPath := self textEntry: 'Enter the path for the new directory.' title: 'New Directory' completeAfter: self selectedFile fullName , FileSystem disk delimiter asString.
	newDirectoryPath ifNil: [ ^ self ].
	
	newDirectoryPath := newDirectoryPath asFileReference.
	newDirectoryPath exists ifTrue: [
		^ UIManager default message: 'Cannot create directory because it already exists.' title: 'Directory Creation Error'. 
	].

	newDirectoryPath createDirectory.
	treeMorph dataSource updateData.
	