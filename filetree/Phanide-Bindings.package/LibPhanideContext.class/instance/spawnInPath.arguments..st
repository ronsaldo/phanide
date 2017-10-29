process
spawnInPath: file arguments: arguments
	^ self ffiCall: #(phanide_process_t phanide_process_spawnInPath(self, String file, String* arguments))