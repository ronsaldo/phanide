operations
create: semaphoreIndex
	^ self ffiCall: #(phanide_context_t phanide_createContext(size_t semaphoreIndex))