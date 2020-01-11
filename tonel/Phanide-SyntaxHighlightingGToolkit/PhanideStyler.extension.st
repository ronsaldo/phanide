Extension { #name : #PhanideStyler }

{ #category : #'*Phanide-SyntaxHighlightingGToolkit' }
PhanideStyler >> asBlocStyler [
	^ PhanideBlTextStylerAdapter new
		phanideStyler: self;
		yourself
]

{ #category : #'*Phanide-SyntaxHighlightingGToolkit' }
PhanideStyler >> styleBlocText: aText fromFileReference: fileReference [
	^ self styleBlocText: aText fromFileReference: fileReference withStyleTable: PhanideSyntaxStyleTable current
]

{ #category : #'*Phanide-SyntaxHighlightingGToolkit' }
PhanideStyler >> styleBlocText: aText fromFileReference: fileReference withStyleTable: styleTable [
	self subclassResponsibility
]
