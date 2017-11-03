as yet unclassified
rubricEditingModeForFileReference: aFileReference
	^ GLMHighlighterTextRubEditingMode withStylerDecorator: (
			PhanideTextStylerDecorator new
				phanideStyler: self;
				fileReference: aFileReference;
				yourself
			)