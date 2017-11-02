named components
removeComponent: aComponent
	(componentDictionary includesKey: aComponent name) ifTrue: [
		componentDictionary removeKey: aComponent name
	].