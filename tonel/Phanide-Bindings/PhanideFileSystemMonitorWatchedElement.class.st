"
I am a watched element by the file system monitor.
"
Class {
	#name : #PhanideFileSystemMonitorWatchedElement,
	#superclass : #Object,
	#instVars : [
		'handle',
		'announcer',
		'fileReference'
	],
	#pools : [
		'LibPhanidePool'
	],
	#category : 'Phanide-Bindings-FileSystem'
}

{ #category : #'instance creation' }
PhanideFileSystemMonitorWatchedElement class >> for: aFileReference [
	^ self basicNew initializeFor: aFileReference
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> announcer [
	^ announcer
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> announcer: anObject [
	announcer := anObject
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> handle [
	^ handle
]

{ #category : #accessing }
PhanideFileSystemMonitorWatchedElement >> handle: anObject [
	handle := anObject
]

{ #category : #initialization }
PhanideFileSystemMonitorWatchedElement >> initializeFor: aFileReference [
	fileReference := aFileReference.
	announcer := Announcer new.
	
	aFileReference isDirectory ifTrue: [
		handle := PhanideDriver uniqueInstance watchDirectory: aFileReference fullName eventHandler: [ :event | self processEvent: event ]
	] ifFalse: [
		handle := PhanideDriver uniqueInstance watchFile: aFileReference fullName eventHandler: [ :event | self processEvent: event ]
	]
]

{ #category : #events-processing }
PhanideFileSystemMonitorWatchedElement >> processEvent: rawEvent [
	| elementFileReference mask |
	elementFileReference := rawEvent name ifNil: [ fileReference ] ifNotNil: [ fileReference / rawEvent name ].
	
	mask := rawEvent mask.
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_ACCESS) ifTrue: [
		announcer announce: (PhanideFileEventAccess new
			fileReference: fileReference;
			elementFileReference: elementFileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_ATTRIB) ifTrue: [ 
		announcer announce: (PhanideFileEventAttrib new
			fileReference: fileReference;
			elementFileReference: elementFileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_CLOSE_WRITE) ifTrue: [ 
		announcer announce: (PhanideFileEventCloseWrite new
			fileReference: fileReference;
			elementFileReference: elementFileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_CLOSE_NOWRITE) ifTrue: [ 
		announcer announce: (PhanideFileEventCloseNoWrite new
			fileReference: fileReference;
			elementFileReference: elementFileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_CREATE) ifTrue: [ 
		announcer announce: (PhanideFileEventCreate new
			fileReference: fileReference;
			elementFileReference: elementFileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_DELETE) ifTrue: [ 
		announcer announce: (PhanideFileEventDelete new
			fileReference: fileReference;
			elementFileReference: elementFileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_DELETE_SELF) ifTrue: [ 
		announcer announce: (PhanideFileEventDelete new
			fileReference: fileReference;
			elementFileReference: elementFileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_MODIFY) ifTrue: [ 
		announcer announce: (PhanideFileEventModify new
			fileReference: fileReference;
			elementFileReference: elementFileReference;
			yourself)
	].

	(mask anyMask: PHANIDE_FSMONITOR_EVENT_OPEN) ifTrue: [ 
		announcer announce: (PhanideFileEventOpen new
			fileReference: fileReference;
			elementFileReference: elementFileReference;
			yourself)
	].

"	PHANIDE_FSMONITOR_EVENT_MOVE_SELF := 1<<8.
	PHANIDE_FSMONITOR_EVENT_MOVED_FROM := 1<<9.
	PHANIDE_FSMONITOR_EVENT_MOVED_TO := 1<<10."

]
