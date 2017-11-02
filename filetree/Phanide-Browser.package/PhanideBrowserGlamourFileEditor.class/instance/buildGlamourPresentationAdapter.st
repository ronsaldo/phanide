initialization
buildGlamourPresentationAdapter
	| morph |
	presentation := self createGlamourPresentation.
	morph := GLMMorphicRenderer new render: presentation.
	morph hResizing: #spaceFill.
	morph vResizing: #spaceFill.
	^ MorphicGenericAdapter morph: morph.