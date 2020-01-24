"
I am a libphanide FS monitor event.
"
Class {
	#name : #LibPhanideEventFSMonitor,
	#superclass : #FFIExternalStructure,
	#classVars : [
		'OFFSET_COOKIE',
		'OFFSET_HANDLE',
		'OFFSET_MASK',
		'OFFSET_NAME',
		'OFFSET_NAMELENGTH',
		'OFFSET_TYPE'
	],
	#pools : [
		'LibPhanidePool'
	],
	#category : #'Phanide-Bindings-Bindings'
}

{ #category : #'field definition' }
LibPhanideEventFSMonitor class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^ #(
		uint32 type;
		phanide_fsmonitor_handle_t handle;
    	uint32 mask;
    	uint32 cookie;
    	uint32 nameLength;
    	char* name;
	)
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> cookie [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_COOKIE
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> cookie: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_COOKIE put: anObject
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> handle [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_HANDLE) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> handle: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_HANDLE put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> mask [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_MASK
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> mask: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_MASK put: anObject
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> name [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_NAME) type: ExternalType char asPointerType
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> name: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_NAME put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> nameLength [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_NAMELENGTH
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> nameLength: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_NAMELENGTH put: anObject
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> type [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_TYPE
]

{ #category : #'accessing structure variables' }
LibPhanideEventFSMonitor >> type: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_TYPE put: anObject
]
