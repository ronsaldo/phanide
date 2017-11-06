accessing
fileName
	^ fileReference ifNil: [ 'Unnamed' ] ifNotNil: [ fileReference basename ]