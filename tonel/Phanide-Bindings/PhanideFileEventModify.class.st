"
I am an event that notifies the modification of a file or a directory. I may not be the final modification of a particular, so the file could be in an inconsistent state.
"
Class {
	#name : #PhanideFileEventModify,
	#superclass : #PhanideFileEvent,
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #converting }
PhanideFileEventModify >> asCloseWriteEvent [
	^ PhanideFileEventCloseWrite new fileReference: fileReference
]

{ #category : #testing }
PhanideFileEventModify >> isModify [
	^ true
]
