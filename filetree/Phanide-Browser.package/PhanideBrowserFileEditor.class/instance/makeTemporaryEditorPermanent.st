as yet unclassified
makeTemporaryEditorPermanent
	temporaryEditor ifTrue: [ 
		browser makeTemporaryEditorPermanent: self
	]
