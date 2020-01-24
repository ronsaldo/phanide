"
I am an event that notifies the deletion of a file in a directory.
"
Class {
	#name : #PhanideFileEventDelete,
	#superclass : #PhanideFileEvent,
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #testing }
PhanideFileEventDelete >> isDelete [
	^ true
]
