initialize
destroy
	^ self ffiCall: #(void phanide_destroyContext(this))