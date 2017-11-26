initialization
initializeWidgets
 
	| ds |
	fileReferenceToNodeDictionary := Dictionary new.
	ds := PhanideFileTreeDataSource
		roots: {browser baseDirectory}
		children: [ :data :item | self childrenFor: data item: item ].
	ds model: self.
	treeMorph := FTTableMorph new
		dataSource: ds;
		explicitFunction;
		beMultipleSelection.
		
	treeMorph
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	tree := treeMorph asSpecAdapter.