testing
acceptsCharacter: aCharacter
	^ components detect: [ :comp | comp acceptsCharacter: aCharacter ] ifFound: [ true ] ifNone: [ false ]