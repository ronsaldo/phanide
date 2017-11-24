as yet unclassified
textDecoratorInPresentation: rubPresentation fileReference: aFileReference
	^ PhanideTextStylerDecorator new
			phanideStyler: self;
			fileReference: aFileReference;
			yourself