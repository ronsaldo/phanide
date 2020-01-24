"
I am a file event that notifies that file attributes such as access permissions have changed.
"
Class {
	#name : #PhanideFileEventAttrib,
	#superclass : #PhanideFileEvent,
	#category : #'Phanide-Bindings-FileSystem'
}

{ #category : #testing }
PhanideFileEventAttrib >> isAttrib [
	^ true
]
