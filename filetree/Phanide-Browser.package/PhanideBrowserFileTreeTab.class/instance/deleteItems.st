menus
deleteItems
	| question selectedFiles |
	question := UIManager default questionWithoutCancel: 'Are you sure that you want to delete permanently the selected files?' title: 'Are you sure?'.
	question ifFalse: [ ^ self ].
	
	selectedFiles := self selectedFiles.
	selectedFiles do: [ :f |
		f exists ifTrue: [
			f isFile ifTrue: [ f delete ] ifFalse: [ f deleteAll ]
		].
	].
	treeMorph dataSource updateData.
	