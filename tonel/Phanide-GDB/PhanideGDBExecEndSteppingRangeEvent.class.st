Class {
	#name : #PhanideGDBExecEndSteppingRangeEvent,
	#superclass : #PhanideGDBExecStopInFrameEvent,
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #visiting }
PhanideGDBExecEndSteppingRangeEvent >> processWith: eventHandler [
	^ eventHandler onExecEndSteppingRange: self
]
