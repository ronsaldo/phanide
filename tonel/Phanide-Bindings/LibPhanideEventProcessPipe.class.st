Class {
	#name : #LibPhanideEventProcessPipe,
	#superclass : #FFIExternalStructure,
	#classVars : [
		'OFFSET_PIPEINDEX',
		'OFFSET_PROCESS',
		'OFFSET_TYPE'
	],
	#pools : [
		'LibPhanidePool'
	],
	#category : 'Phanide-Bindings-Bindings'
}

{ #category : #'field definition' }
LibPhanideEventProcessPipe class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^ #(
		uint32 type;
		phanide_process_t process;
		uint32 pipeIndex;
	)
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessPipe >> pipeIndex [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_PIPEINDEX
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessPipe >> pipeIndex: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_PIPEINDEX put: anObject
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessPipe >> process [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_PROCESS) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessPipe >> process: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_PROCESS put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessPipe >> type [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_TYPE
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessPipe >> type: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_TYPE put: anObject
]
