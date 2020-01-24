Class {
	#name : #PhanideFileSystemMonitorUnprocessedEvent,
	#superclass : #Object,
	#instVars : [
		'mask',
		'name',
		'fileReference',
		'timeStamp'
	],
	#pools : [
		'LibPhanidePool'
	],
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #'as yet unclassified' }
PhanideFileSystemMonitorUnprocessedEvent >> deliverWithWatcher: watcher [
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_ACCESS) ifTrue: [
		watcher deliverProcessedEvent: (PhanideFileEventAccess new
			fileReference: fileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_ATTRIB) ifTrue: [ 
		watcher deliverProcessedEvent: (PhanideFileEventAttrib new
			fileReference: fileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_CLOSE_WRITE) ifTrue: [ 
		watcher deliverProcessedEvent: (PhanideFileEventCloseWrite new
			fileReference: fileReference;
			yourself).
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_CLOSE_NOWRITE) ifTrue: [ 
		watcher deliverProcessedEvent: (PhanideFileEventCloseNoWrite new
			fileReference: fileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_CREATE) ifTrue: [ 
		watcher deliverProcessedEvent: (PhanideFileEventCreate new
			fileReference: fileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_DELETE) ifTrue: [ 
		watcher deliverProcessedEvent: (PhanideFileEventDelete new
			fileReference: fileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_DELETE_SELF) ifTrue: [ 
		watcher deliverProcessedEvent: (PhanideFileEventDelete new
			fileReference: fileReference;
			yourself)
	].
	(mask anyMask: PHANIDE_FSMONITOR_EVENT_MODIFY) ifTrue: [ 
		watcher deliverProcessedEvent: (PhanideFileEventModify new
			fileReference: fileReference;
			yourself).
	].

	(mask anyMask: PHANIDE_FSMONITOR_EVENT_OPEN) ifTrue: [ 
		watcher deliverProcessedEvent: (PhanideFileEventOpen new
			fileReference: fileReference;
			yourself)
	].
]

{ #category : #accessing }
PhanideFileSystemMonitorUnprocessedEvent >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideFileSystemMonitorUnprocessedEvent >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #accessing }
PhanideFileSystemMonitorUnprocessedEvent >> mask [
	^ mask
]

{ #category : #accessing }
PhanideFileSystemMonitorUnprocessedEvent >> mask: anObject [
	mask := anObject
]

{ #category : #accessing }
PhanideFileSystemMonitorUnprocessedEvent >> name [
	^ name
]

{ #category : #accessing }
PhanideFileSystemMonitorUnprocessedEvent >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PhanideFileSystemMonitorUnprocessedEvent >> timeStamp [
	^ timeStamp
]

{ #category : #accessing }
PhanideFileSystemMonitorUnprocessedEvent >> timeStamp: anObject [
	timeStamp := anObject
]
