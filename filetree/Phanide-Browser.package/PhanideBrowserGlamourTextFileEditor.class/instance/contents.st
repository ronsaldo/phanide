accessing
contents
	^ fileReference ifNil: [ '' ] ifNotNil: [ fileReference contents ]