Class {
	#name : #PhanideFileEventCloseWrite,
	#superclass : #PhanideFileEvent,
	#category : 'Phanide-Bindings-FileSystem'
}

{ #category : #testing }
PhanideFileEventCloseWrite class >> isPreferredInParentFolder [
	^ true
]
