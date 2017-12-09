initialize-release
destroyOnContext: context
	^ self ffiCall: #(void phanide_fsmonitor_destroy(phanide_context_t context, self))