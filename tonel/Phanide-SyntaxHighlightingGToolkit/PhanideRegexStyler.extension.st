Extension { #name : #PhanideRegexStyler }

{ #category : #'*Phanide-SyntaxHighlightingGToolkit' }
PhanideRegexStyler >> styleBlocText: aText fromFileReference: fileReference withStyleTable: styleTable [
	lexer styleBlocText: aText withStyleTable: styleTable
]
