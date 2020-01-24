"
I am an event that notifies that a process has closed a handle accessing the file without modifying.
"
Class {
	#name : #PhanideFileEventCloseNoWrite,
	#superclass : #PhanideFileEvent,
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #testing }
PhanideFileEventCloseNoWrite >> isCloseNoWrite [
	^ true
]
