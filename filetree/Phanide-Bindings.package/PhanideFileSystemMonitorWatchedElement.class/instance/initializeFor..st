initialization
initializeFor: aFileReference
	fileReference := aFileReference.
	announcer := Announcer new.
	
	aFileReference isDirectory ifTrue: [
		handle := PhanideDriver uniqueInstance watchDirectory: aFileReference fullName eventHandler: [ :event | self processEvent: event ]
	] ifFalse: [
		handle := PhanideDriver uniqueInstance watchFile: aFileReference fullName eventHandler: [ :event | self processEvent: event ]
	]