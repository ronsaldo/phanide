pipes
pipe: aPipeIndex readInto: aBuffer offset: aBufferOffset count: aBufferSize
	^ self ffiCall: #(long phanide_process_pipe_read(self, int aPipeIndex, ByteArray aBuffer, size_t aBufferOffset, size_t aBufferSize))