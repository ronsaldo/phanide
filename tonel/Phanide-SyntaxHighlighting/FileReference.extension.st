Extension { #name : #FileReference }

{ #category : #'*Phanide-SyntaxHighlighting' }
FileReference >> gtInspectorPhanideIn: composite [
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
		display: [ (self readStreamDo: #contents) withSqueakLineEndings ];
		act: [:rub | 
			self 
				ensureDelete; 
				writeStreamDo: [ :s | s nextPutAll: rub text asString copy withUnixLineEndings ]] 
			icon: GLMUIThemeExtraIcons glamorousSave 
			on: $s
			entitled: 'Save')
]
