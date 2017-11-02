accessing
label
	^ label ifNil: [ label := self defaultLabel ]