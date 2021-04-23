Extension { #name : #FileReference }

{ #category : #'*Phanide-SyntaxHighlighting' }
FileReference >> inspectionPhanide [
	<inspectorPresentationOrder: 0 title: 'Phanide'>
	
	^ SpRichTextPresenter new
		text: self contents;
		textStyler: ((PhanideStyler forFileReference: self) asSpTextStyler fileReference: self; yourself);
		yourself
]

{ #category : #'*Phanide-SyntaxHighlighting' }
FileReference >> inspectionPhanideContext: aContext [	
	self exists ifFalse: [ ^ aContext beInactive ].
	(PhanideStyler forFileReference: self) ifNil: [ ^ aContext beInactive ].
	aContext beActive
]
