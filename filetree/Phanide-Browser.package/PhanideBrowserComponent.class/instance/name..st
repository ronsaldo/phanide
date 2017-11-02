accessing
name: aNewName
	name ifNotNil: [ browser component: self renamedFrom: name into: aNewName ].
	name := aNewName