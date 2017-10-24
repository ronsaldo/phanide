initialization
initialize 
	handle value = 0 ifTrue: [ 
		self error: 'Error creating new context' ].
	FFIExternalResourceManager addResource: self data: handle