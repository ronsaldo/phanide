Class {
	#name : #PhanideGDBExecExitedEvent,
	#superclass : #PhanideGDBExecStoppedEvent,
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #visiting }
PhanideGDBExecExitedEvent >> processWith: eventHandler [
	^ eventHandler onExecExitedEvent: self
]
