named components
component: component renamedFrom: oldName into: newName
	oldName = newName ifTrue: [ ^ self ].
	
	componentDictionary at: oldName ifPresent: [ 
		componentDictionary removeKey: oldName.
		componentDictionary at: newName put: component
	]