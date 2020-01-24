"
I am a handle to a subprocess that is created by using libphanide.
"
Class {
	#name : #LibPhanideProcess,
	#superclass : #LibPhanideHandle,
	#category : #'Phanide-Bindings-Bindings'
}

{ #category : #actions }
LibPhanideProcess >> destroy [
	^ self ffiCall: #(void phanide_process_free(self))
]

{ #category : #actions }
LibPhanideProcess >> kill [
	^ self ffiCall: #(void phanide_process_kill(self))
]

{ #category : #pipes }
LibPhanideProcess >> pipe: aPipeIndex readInto: aBuffer offset: aBufferOffset count: aBufferSize [
	^ self ffiCall: #(long phanide_process_pipe_read(self, int aPipeIndex, ByteArray aBuffer, size_t aBufferOffset, size_t aBufferSize))
]

{ #category : #pipes }
LibPhanideProcess >> pipe: aPipeIndex writeFrom: aBuffer offset: aBufferOffset count: aBufferSize [
	^ self ffiCall: #(long phanide_process_pipe_write(self, int aPipeIndex, ByteArray aBuffer, size_t aBufferOffset, size_t aBufferSize))
]

{ #category : #actions }
LibPhanideProcess >> terminate [
	^ self ffiCall: #(void phanide_process_terminate(self))
]
