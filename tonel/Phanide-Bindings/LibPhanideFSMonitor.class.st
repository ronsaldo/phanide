"
I am a handle to a file system monitor object that is used for receiving events about the changes in a file or directory, if supported by the underlying platform specific APIs.
"
Class {
	#name : #LibPhanideFSMonitor,
	#superclass : #LibPhanideHandle,
	#category : #'Phanide-Bindings-Bindings'
}

{ #category : #'initialize-release' }
LibPhanideFSMonitor >> destroyOnContext: context [
	^ self ffiCall: #(void phanide_fsmonitor_destroy(phanide_context_t context, self))
]

{ #category : #'initialize-release' }
LibPhanideFSMonitor >> supportedEventMask [
	^ self ffiCall: #(uint phanide_fsmonitor_getSupportedEventMask(self))
]
