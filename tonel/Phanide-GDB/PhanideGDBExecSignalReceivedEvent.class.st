Class {
	#name : #PhanideGDBExecSignalReceivedEvent,
	#superclass : #PhanideGDBExecStopInFrameEvent,
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #visiting }
PhanideGDBExecSignalReceivedEvent >> processWith: eventHandler [
	^ eventHandler onExecSignalReceived: self
]
