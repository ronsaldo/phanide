Class {
	#name : #LibPhanideEvent,
	#superclass : #FFIExternalUnion,
	#classVars : [
		'padding16'
	],
	#pools : [
		'LibPhanidePool'
	],
	#category : 'Phanide-Bindings-Bindings'
}

{ #category : #'field definition' }
LibPhanideEvent class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^ #(
		uint32 type;
		phanide_event_process_pipe_t processPipe;
		phanide_event_process_finished_t processFinished;
		phanide_event_fsmonitor_t fsmonitor;
		padding16 padding;
	)
]

{ #category : #initialization }
LibPhanideEvent class >> initialize [
	padding16 := FFITypeArray ofType: #size_t size: 16.
]

{ #category : #'accessing structure variables' }
LibPhanideEvent >> fsmonitor [
	"This method was automatically generated"
	^ LibPhanideEventFSMonitor fromHandle: (handle referenceStructAt: 1 length: LibPhanideEventFSMonitor byteSize)
]

{ #category : #'accessing structure variables' }
LibPhanideEvent >> fsmonitor: anObject [
	"This method was automatically generated"
	handle structAt: 1 put: anObject getHandle length: 24.
]

{ #category : #'accessing structure variables' }
LibPhanideEvent >> padding [
	"This method was automatically generated"
	^(FFITypeArray ofType: #FFIULong size: 16) fromHandle: (handle copyFrom: 1 to: 64)
]

{ #category : #'accessing structure variables' }
LibPhanideEvent >> padding: anObject [
	"This method was automatically generated"
	handle replaceFrom: 1 to: 64 with: anObject getHandle startingAt: 1
]

{ #category : #'accessing structure variables' }
LibPhanideEvent >> processFinished [
	"This method was automatically generated"
	^ LibPhanideEventProcessFinished fromHandle: (handle referenceStructAt: 1 length: LibPhanideEventProcessFinished byteSize)
]

{ #category : #'accessing structure variables' }
LibPhanideEvent >> processFinished: anObject [
	"This method was automatically generated"
	handle structAt: 1 put: anObject getHandle length: 12.
]

{ #category : #'accessing structure variables' }
LibPhanideEvent >> processPipe [
	"This method was automatically generated"
	^ LibPhanideEventProcessPipe fromHandle: (handle referenceStructAt: 1 length: LibPhanideEventProcessPipe byteSize)
]

{ #category : #'accessing structure variables' }
LibPhanideEvent >> processPipe: anObject [
	"This method was automatically generated"
	handle structAt: 1 put: anObject getHandle length: 12.
]

{ #category : #'accessing structure variables' }
LibPhanideEvent >> type [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #'accessing structure variables' }
LibPhanideEvent >> type: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]
