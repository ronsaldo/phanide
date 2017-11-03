initialization
initializeWidgets
	morph := self createMorph.
	morph
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	morphModel := morph asSpecAdapter.
	self setupMorph.