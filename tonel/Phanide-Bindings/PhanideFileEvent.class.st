"
I am file related to event. My subclasses are announced when a monitored file or directory suffers some changes.
"
Class {
	#name : #PhanideFileEvent,
	#superclass : #Announcement,
	#instVars : [
		'fileReference',
		'elementFileReference'
	],
	#category : 'Phanide-Bindings-FileSystem'
}

{ #category : #testing }
PhanideFileEvent class >> isPreferredInParentFolder [
	^ false
]

{ #category : #accessing }
PhanideFileEvent >> elementFileReference [
	^ elementFileReference
]

{ #category : #accessing }
PhanideFileEvent >> elementFileReference: anObject [
	elementFileReference := anObject
]

{ #category : #accessing }
PhanideFileEvent >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideFileEvent >> fileReference: anObject [
	fileReference := anObject
]
