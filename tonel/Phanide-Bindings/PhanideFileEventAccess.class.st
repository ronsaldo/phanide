"
I am an event that notifies that a file is being accessed by some process. I may not be always supported.
"
Class {
	#name : #PhanideFileEventAccess,
	#superclass : #PhanideFileEvent,
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #testing }
PhanideFileEventAccess >> isAccess [
	^ true
]
