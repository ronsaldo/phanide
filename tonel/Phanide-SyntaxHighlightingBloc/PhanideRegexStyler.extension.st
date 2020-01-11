Extension { #name : #PhanideRegexStyler }

{ #category : #'*Phanide-SyntaxHighlightingBloc' }
PhanideRegexStyler >> styleBlocText: aText fromFileReference: fileReference withStyleTable: styleTable [
	lexer styleBlocText: aText withStyleTable: styleTable
]
