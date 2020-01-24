"
I am handle to a context object in libphanide.
"
Class {
	#name : #LibPhanideContext,
	#superclass : #LibPhanideHandle,
	#category : #'Phanide-Bindings-Bindings'
}

{ #category : #operations }
LibPhanideContext class >> create [
	^ self create: 0
]

{ #category : #operations }
LibPhanideContext class >> create: semaphoreIndex [
	^ self ffiCall: #(phanide_context_t phanide_createContext(size_t semaphoreIndex))
]

{ #category : #events }
LibPhanideContext >> canCreateNamedExtraPipes [
	^ self isCapabilitySupported: PHANIDE_CAPABILITY_NAMED_EXTRA_PIPES
]

{ #category : #events }
LibPhanideContext >> canCreateNumberedExtraPipes [
	^ self isCapabilitySupported: PHANIDE_CAPABILITY_NUMBERED_EXTRA_PIPES
]

{ #category : #events }
LibPhanideContext >> canSignalExternalSemaphore [
	^ self isCapabilitySupported: PHANIDE_CAPABILITY_EXTERNAL_SEMAPHORE_SIGNALING
]

{ #category : #initialize }
LibPhanideContext >> destroy [
	^ self ffiCall: #(void phanide_destroyContext(this))
]

{ #category : #events }
LibPhanideContext >> fsMonitorCanWatchDirectories [
	^ self isCapabilitySupported: PHANIDE_CAPABILITY_FSMONITOR_WATCH_DIRECTORIES
]

{ #category : #events }
LibPhanideContext >> fsMonitorCanWatchDirectoryFileModifications [
	^ self isCapabilitySupported: PHANIDE_CAPABILITY_FSMONITOR_WATCH_DIRECTORY_FILE_MODIFICATIONS
]

{ #category : #events }
LibPhanideContext >> fsMonitorCanWatchFiles [
	^ self isCapabilitySupported: PHANIDE_CAPABILITY_FSMONITOR_WATCH_FILES
]

{ #category : #events }
LibPhanideContext >> fsMonitorHasCookie [
	^ self isCapabilitySupported: PHANIDE_CAPABILITY_FSMONITOR_COOKIE
]

{ #category : #initialization }
LibPhanideContext >> initialize [ 
	handle value = 0 ifTrue: [ 
		self error: 'Error creating new context' ].
	FFIExternalResourceManager addResource: self data: handle
]

{ #category : #events }
LibPhanideContext >> isCapabilitySupported: capability [
	^ self ffiCall: #(bool phanide_isCapabilitySupported(self, int capability))
]

{ #category : #events }
LibPhanideContext >> pollEvent: anEvent [
	^ self ffiCall: #(bool phanide_pollEvent(self, phanide_event_t *anEvent))
]

{ #category : #events }
LibPhanideContext >> pushEvent: anEvent [
	^ self ffiCall: #(int phanide_pushEvent(self, phanide_event_t *anEvent))
]

{ #category : #process }
LibPhanideContext >> spawn: path arguments: arguments [
	^ self spawn: path arguments: arguments flags: PHANIDE_SPAWN_FLAGS_NONE
]

{ #category : #process }
LibPhanideContext >> spawn: path arguments: arguments flags: flags [
	^ self ffiCall: #(phanide_process_t phanide_process_spawnInPath(self, String path, String* arguments, int flags))
]

{ #category : #process }
LibPhanideContext >> spawnInPath: file arguments: arguments [
	^ self spawnInPath: file arguments: arguments flags: PHANIDE_SPAWN_FLAGS_NONE
]

{ #category : #process }
LibPhanideContext >> spawnInPath: file arguments: arguments flags: flags [
	^ self ffiCall: #(phanide_process_t phanide_process_spawnInPath(self, String file, String* arguments, int flags))
]

{ #category : #process }
LibPhanideContext >> spawnShell: command [
	^ self spawnShell: command flags: PHANIDE_SPAWN_FLAGS_NONE
]

{ #category : #process }
LibPhanideContext >> spawnShell: command flags: flags [
	^ self ffiCall: #(phanide_process_t phanide_process_spawnShell(self, String command, int flags))
]

{ #category : #events }
LibPhanideContext >> waitEvent: anEvent [
	^ self ffiCall: #(bool phanide_waitEvent(self, phanide_event_t *anEvent))
]

{ #category : #'file system' }
LibPhanideContext >> watchDirectory: path [
	^ self ffiCall: #(phanide_fsmonitor_handle_t phanide_fsmonitor_watchDirectory(self, String path))
]

{ #category : #'file system' }
LibPhanideContext >> watchFile: path [
	^ self ffiCall: #(phanide_fsmonitor_handle_t phanide_fsmonitor_watchFile(self, String path))
]
