as yet unclassified
styleText: aText
	phanideStyler ifNil: [ ^ nil ].
	^ phanideStyler styleText: aText fromFileReference: fileReference