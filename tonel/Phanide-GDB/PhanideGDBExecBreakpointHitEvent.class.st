Class {
	#name : #PhanideGDBExecBreakpointHitEvent,
	#superclass : #PhanideGDBExecStoppedEvent,
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #visiting }
PhanideGDBExecBreakpointHitEvent >> processWith: eventHandler [
	^ eventHandler onExecBreakpointHitEvent: self
]
