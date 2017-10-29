process
spawn: path arguments: arguments
	^ self ffiCall: #(phanide_process_t phanide_process_spawnInPath(self, String path, String* arguments))