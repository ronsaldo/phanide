named components
registerNamedComponent: tabModel
	componentDictionary at: tabModel name
		ifPresent: [ self error: 'Adding clashing Phanide browser component.' ]
		ifAbsentPut: [ tabModel ]