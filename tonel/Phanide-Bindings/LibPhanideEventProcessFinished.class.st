"
I am a libphanide process finished event.
"
Class {
	#name : #LibPhanideEventProcessFinished,
	#superclass : #FFIExternalStructure,
	#classVars : [
		'OFFSET_EXITCODE',
		'OFFSET_PROCESS',
		'OFFSET_TYPE'
	],
	#pools : [
		'LibPhanidePool'
	],
	#category : #'Phanide-Bindings-Bindings'
}

{ #category : #'field definition' }
LibPhanideEventProcessFinished class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^ #(
		uint32 type;
		phanide_process_t process;
		int32 exitCode;
	)
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessFinished >> exitCode [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_EXITCODE
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessFinished >> exitCode: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_EXITCODE put: anObject
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessFinished >> process [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_PROCESS) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessFinished >> process: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_PROCESS put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessFinished >> type [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_TYPE
]

{ #category : #'accessing structure variables' }
LibPhanideEventProcessFinished >> type: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_TYPE put: anObject
]
