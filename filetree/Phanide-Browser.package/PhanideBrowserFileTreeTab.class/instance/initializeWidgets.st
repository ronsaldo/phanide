initialization
initializeWidgets
	"Code taken from: http://forum.world.st/Spec-gt-TreeModel-Updating-the-tree-selection-after-a-deletion-td4909894.html"
	
	tree := self instantiate: SearchableTree.
	
	nodeBlock := [:fileReference |
		|node|
		node := TreeNodeModel new.
		node hasChildren: [ fileReference isDirectory ].
		node icon: (fileReference isDirectory 
				ifTrue: [ GLMUIThemeExtraIcons glamorousFolder ] 
				ifFalse: [ GLMUIThemeExtraIcons glamorousBrowse ]).
		node children: [
			(fileReference children
				sorted: [ :a :b |
					a isDirectory == b isDirectory ifTrue: [ 
						a basename <= b basename
					] ifFalse: [
						a isDirectory asBit >= b isDirectory asBit
					]
				]
			) collect: nodeBlock
		].
		node content: fileReference.
	].
	tree
		multiSelection: true;
		roots: {nodeBlock value: browser baseDirectory};
		displayBlock: [ :item | item basename ];
		whenBuiltDo: [ tree selectedItem: (tree roots first selected: true; takeHighlight; yourself) ]