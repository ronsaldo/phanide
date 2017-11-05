copying
copyWithRenameDictionary: renameDictionary
	^ self copy targets: (targets collect: [:t | renameDictionary at: t]) flattened