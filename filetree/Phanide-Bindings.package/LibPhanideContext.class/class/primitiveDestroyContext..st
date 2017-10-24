operations
primitiveDestroyContext: aHandle
	^ self ffiCall: #(void phanide_destroyContext(void *aHandle))