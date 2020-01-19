Extension { #name : #FileReference }

{ #category : #'*Phanide-SyntaxHighlightingGToolkit' }
FileReference >> gtPhanideStylingIn: aView [
	<gtView>
	| styler blocStyler |
	styler := PhanideStyler forFileReference: self.
	styler ifNil: [ ^ aView empty ].
	
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
