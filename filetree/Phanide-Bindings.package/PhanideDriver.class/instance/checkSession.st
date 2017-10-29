session checking
checkSession
	session ~~ Smalltalk session ifTrue: [ 
		self initializeForNewSession
	]