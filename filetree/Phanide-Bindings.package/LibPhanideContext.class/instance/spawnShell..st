process
spawnShell: command
	^ self ffiCall: #(phanide_process_t phanide_process_spawnShell(self, String command))