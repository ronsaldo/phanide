Extension { #name : #PhanideHighlightCommandStyle }

{ #category : #'*Phanide-SyntaxHighlightingBloc' }
PhanideHighlightCommandStyle >> executeOnBlocText: aBlText withStyleTable: styleTable [
	| attributes |
	attributes := styleTable textAttributesForStyle: style.
	attributes ifEmpty: [ ^ self ].
	(aBlText from: start to: stop) stylerDo: [:subTextStyler |
		attributes do: [ :attribute |
			attribute applyToBlText: subTextStyler
		]
	]
]
