Extension { #name : #PhanideStyler }

{ #category : #'*Phanide-SyntaxHighlightingBloc' }
PhanideStyler >> asBlocStyler [
	^ PhanideBlTextStylerAdapter new
		phanideStyler: self;
		yourself
]

{ #category : #'*Phanide-SyntaxHighlightingBloc' }
PhanideStyler >> styleBlocText: aText fromFileReference: fileReference [
	^ self styleBlocText: aText fromFileReference: fileReference withStyleTable: PhanideSyntaxStyleTable current
]

{ #category : #'*Phanide-SyntaxHighlightingBloc' }
PhanideStyler >> styleBlocText: aText fromFileReference: fileReference withStyleTable: styleTable [
	self subclassResponsibility
]
