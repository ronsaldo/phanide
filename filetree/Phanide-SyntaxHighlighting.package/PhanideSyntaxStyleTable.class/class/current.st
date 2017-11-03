accessing
current
	^ CurrentStyleTable ifNil: [ CurrentStyleTable := self parse: self findCurrentStyleTable ]