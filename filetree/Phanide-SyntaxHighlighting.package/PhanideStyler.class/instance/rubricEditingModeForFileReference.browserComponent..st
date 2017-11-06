as yet unclassified
rubricEditingModeForFileReference: aFileReference browserComponent: browserComponent
	^ PhanideHighlighterTextRubEditingMode new
		browserComponent: browserComponent;
		stylerDecorator: (
			PhanideTextStylerDecorator new
				phanideStyler: self;
				fileReference: aFileReference;
				yourself
		);
		yourself