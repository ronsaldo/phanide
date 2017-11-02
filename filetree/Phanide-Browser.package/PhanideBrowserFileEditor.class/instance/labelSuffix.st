as yet unclassified
labelSuffix
	^ unsavedChanges ifTrue: [ '*' ] ifFalse: [ '' ]