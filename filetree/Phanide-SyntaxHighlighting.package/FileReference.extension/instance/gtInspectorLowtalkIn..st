*Phanide-SyntaxHighlighting
gtInspectorLowtalkIn: composite
	<gtInspectorPresentationOrder: 0>
	| styler |
	styler := PhanideStyler forFileReference: self.
	styler ifNil: [ ^ self ].
	
	^ composite custom: (GLMRubricHighlightedTextPresentation new
		title: styler name;
		font: StandardFonts codeFont;
		editingMode: [ : rubPresentation |
			GLMHighlighterTextRubEditingMode withStylerDecorator: (
				styler textDecoratorInPresentation: rubPresentation
					fileReference: self)];
		display: [ self readStreamDo: #contents ];
		act: [:rub | 
			self 
				ensureDelete; 
				writeStreamDo: [ :s | s nextPutAll: rub text asString withUnixLineEndings ]] 
			icon: GLMUIThemeExtraIcons glamorousSave 
			on: $s
			entitled: 'Save')