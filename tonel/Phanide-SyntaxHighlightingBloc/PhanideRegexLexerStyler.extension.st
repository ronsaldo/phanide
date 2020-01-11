Extension { #name : #PhanideRegexLexerStyler }

{ #category : #'*Phanide-SyntaxHighlightingBloc' }
PhanideRegexLexerStyler >> styleBlocText: aStringOrText [
	^ self styleBlocText: aStringOrText withStyleTable: PhanideSyntaxStyleTable current
]

{ #category : #'*Phanide-SyntaxHighlightingBloc' }
PhanideRegexLexerStyler >> styleBlocText: aBlText withStyleTable: aStyleTable [
	self styleText: aBlText asString withBlock: [ :style :start :stop |
		(aBlText from: start to: stop) stylerDo: [:subTextStyler |
			(aStyleTable textAttributesForStyle: style) do: [ :attribute |
				attribute applyToBlText: subTextStyler
			]
		]
	].

	^ aBlText
]
