"
I am an event that notifies that a process has closed a handle accessing the file after modifying it. In platforms where I am not directly supported I may be generated after create and modify events.
"
Class {
	#name : #PhanideFileEventCloseWrite,
	#superclass : #PhanideFileEvent,
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #testing }
PhanideFileEventCloseWrite class >> isPreferredInParentFolder [
	^ true
]

{ #category : #testing }
PhanideFileEventCloseWrite >> isCloseWrite [
	^ true
]
