"
I am file related to event. My subclasses are announced when a monitored file or directory suffers some changes.

Some events are directly supported by some platform specific events, and some other events may not be directly supported but in some cases may be inferred. We try to coalesce events in order to reduce spuriuous events, but there is no guarantee that files are in a consistent state after receiving a modification or close write event (e.g. the modification may be incomplete), so it is recommended to handle error if using these events for facilitating live programming.

The names of most of the events come from the inotify linux system call.
"
Class {
	#name : #PhanideFileEvent,
	#superclass : #PhanideEvent,
	#instVars : [
		'fileReference'
	],
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #testing }
PhanideFileEvent class >> isPreferredInParentFolder [
	^ false
]

{ #category : #'as yet unclassified' }
PhanideFileEvent >> deliverWithWatcher: aWatcher [
	^ aWatcher deliverProcessedEvent: self
]

{ #category : #accessing }
PhanideFileEvent >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideFileEvent >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #testing }
PhanideFileEvent >> isAccess [
	^ false
]

{ #category : #testing }
PhanideFileEvent >> isAttrib [
	^ false
]

{ #category : #testing }
PhanideFileEvent >> isCloseNoWrite [
	^ false
]

{ #category : #testing }
PhanideFileEvent >> isCloseWrite [
	^ false
]

{ #category : #testing }
PhanideFileEvent >> isCreate [
	^ false
]

{ #category : #testing }
PhanideFileEvent >> isDelete [
	^ false
]

{ #category : #testing }
PhanideFileEvent >> isModify [
	^ false
]

{ #category : #testing }
PhanideFileEvent >> isMoved [
	^ false
]

{ #category : #testing }
PhanideFileEvent >> isOpen [
	^ false
]
