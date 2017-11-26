accessing
selectedFile
	treeMorph selectedRowIndex = 0 ifTrue: [ ^ nil ].
	^ (treeMorph dataSource elementAt: treeMorph selectedRowIndex) data