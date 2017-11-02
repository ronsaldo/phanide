as yet unclassified
populateComponents
	PhanideBrowserComponent allSubclassesDo: [ :sc |
		sc isPermanentComponent ifTrue: [ 
			self populateComponent: sc
		]
	]