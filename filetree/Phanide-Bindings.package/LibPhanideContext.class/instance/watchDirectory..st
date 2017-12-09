file system
watchDirectory: path
	^ self ffiCall: #(phanide_fsmonitor_handle_t phanide_fsmonitor_watchFile(self, String path))