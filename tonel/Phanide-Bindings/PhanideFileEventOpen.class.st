"
This event notifies that a file has been opened by a process. I may not always be supported, or be disabled for performance reasons.
"
Class {
	#name : #PhanideFileEventOpen,
	#superclass : #PhanideFileEvent,
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #testing }
PhanideFileEventOpen >> isOpen [
	^ true
]
