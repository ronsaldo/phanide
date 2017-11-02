as yet unclassified
onDoubleClick: selectedElements
	| element |
	selectedElements size ~= 1 ifTrue: [ ^ self ].
	
	element := selectedElements first.
	browser openFileView: element content