"
I am an event that notifies the creation of a file in a directory.
"
Class {
	#name : #PhanideFileEventCreate,
	#superclass : #PhanideFileEvent,
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #testing }
PhanideFileEventCreate >> isCreate [
	^ true
]
