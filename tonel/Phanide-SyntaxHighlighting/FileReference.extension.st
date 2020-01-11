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

{ #category : #'*Phanide-SyntaxHighlighting' }
FileReference >> gtPhanideStylingIn: aView [
	<gtView>
	| styler blocStyler |
	styler := PhanideStyler forFileReference: self.
	styler ifNil: [ ^ self ].
	
	blocStyler := styler asBlocStyler.
	
	^ aView explicit
		title: 'Phanide Code';
		priority: 10;
		stencil: [ | editorElement textEditor text |
			textEditor := BrTextEditor new.
			textEditor styler: blocStyler.
			editorElement := BrEditorElement new.
			editorElement editor: textEditor.
			text := self contents asRopedText.
			text glamorousCodeFontDo: #beNotOverwritableByStyler; glamorousCodeSizeDo: #beNotOverwritableByStyler.
			textEditor text: text.
			editorElement
				padding: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			editorElement ]

]
