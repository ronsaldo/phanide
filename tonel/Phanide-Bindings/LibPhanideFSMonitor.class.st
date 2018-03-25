Class {
	#name : #LibPhanideFSMonitor,
	#superclass : #LibPhanideHandle,
	#category : 'Phanide-Bindings-Bindings'
}

{ #category : #initialize-release }
LibPhanideFSMonitor >> destroyOnContext: context [
	^ self ffiCall: #(void phanide_fsmonitor_destroy(phanide_context_t context, self))
]
