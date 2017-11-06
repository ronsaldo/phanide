protocol
okToClose
	| choice |
	unsavedChanges ifTrue: [ 
		choice := self promptForCancel.
		choice ifNil: [ ^ false ].
		choice ifTrue: [
			choice := self save.
			choice ifNil: [ ^ false ]
		].
	].
	^ super okToClose