"
I notify that a file was moved. oldFileReference contains the old location, and newFileReference contains the new location.
"
Class {
	#name : #PhanideFileEventMoved,
	#superclass : #PhanideFileEvent,
	#instVars : [
		'newFileReference'
	],
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #testing }
PhanideFileEventMoved >> isMoved [
	^ true
]

{ #category : #accessing }
PhanideFileEventMoved >> newFileReference [
	^ newFileReference
]

{ #category : #accessing }
PhanideFileEventMoved >> newFileReference: anObject [
	newFileReference := anObject
]

{ #category : #accessing }
PhanideFileEventMoved >> oldFileReference [
	^ fileReference
]
