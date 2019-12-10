"
I represent a read-only pipe from a process.
"
Class {
	#name : #PhanideProcessReadPipe,
	#superclass : #PhanideProcessPipe,
	#category : 'Phanide-Bindings-Driver'
}

{ #category : #'as yet unclassified' }
PhanideProcessReadPipe >> bufferedStream [
	^ PhanideBufferedReadStream on: self
]

{ #category : #accessing }
PhanideProcessReadPipe >> next [
	"Answer the next byte from this pipe, or nil if at the end of the file."

	^ (self next: 1) ifEmpty: [ nil ] ifNotEmpty: [ :data | data first ]
]

{ #category : #accessing }
PhanideProcessReadPipe >> next: n [
	"Return a string with the next n characters of the filestream in it."

	^ self next: n into: (ByteArray new: n)
]

{ #category : #accessing }
PhanideProcessReadPipe >> next: n into: aBuffer [
	| resultCount |
	resultCount := self read: n into: aBuffer.
	^ resultCount = n
		ifTrue: [ aBuffer ]
		ifFalse: [ aBuffer copyFrom: 1 to: resultCount ].
]

{ #category : #accessing }
PhanideProcessReadPipe >> read: n into: aBuffer [
	^ self read: n into: aBuffer offset: 1
]

{ #category : #accessing }
PhanideProcessReadPipe >> read: n into: aBuffer offset: aBufferOffset [
	| resultCount |
	mutex critical: [
		[
			"Wait for the pipe to be ready"
			[processHasFinished or: [ready]] whileFalse: [ readyCondition wait: mutex ].
			processHasFinished ifTrue: [ ^ 0 ].
			
			resultCount := process handle pipe: index readInto: aBuffer offset: aBufferOffset - 1 count: n.
			resultCount = PHANIDE_PIPE_ERROR_WOULD_BLOCK ifTrue: [
				ready := false.
			].
		] doWhileTrue: [ ready not ]
	].

	"Treat a read from a closed pipe as a read of size 1."
	resultCount = PHANIDE_PIPE_ERROR_CLOSED ifTrue: [ 
		resultCount := 0.
	].

	self convertPipeError: resultCount.
	^ resultCount
]

{ #category : #accessing }
PhanideProcessReadPipe >> readInto: aBuffer startingAt: aBufferOffset count: n [
	^ self read: n into: aBuffer offset: aBufferOffset
]

{ #category : #'as yet unclassified' }
PhanideProcessReadPipe >> textStream [
	^ PhanideUTF8TextReadStream on: self bufferedStream
]
