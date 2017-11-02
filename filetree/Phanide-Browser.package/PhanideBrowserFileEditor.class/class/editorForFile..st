as yet unclassified
editorForFile: aFileReference
	self allSubclassesDo: [ :sc |
		(sc isSuitableEditorFor: aFileReference) ifTrue: [ 
			^ sc
		]
	].
	self allSubclassesDo: [ :sc |
		(sc isFallbackEditorFor: aFileReference) ifTrue: [ 
			^ sc
		]
	].
	^ PhanideBrowserHexEditor