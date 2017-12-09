libgit-finalization
free: pointer
	^ self ffiCall: #(void phanide_free(void* pointer))