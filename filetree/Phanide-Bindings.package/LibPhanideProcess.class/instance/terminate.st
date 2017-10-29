actions
terminate
	^ self ffiCall: #(void phanide_process_terminate(this))