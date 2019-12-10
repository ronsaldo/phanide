"
I am event handler for events fired by gdb.
"
Class {
	#name : #PhanideGDBEventHandler,
	#superclass : #Object,
	#category : 'Phanide-GDB-FrontEnd'
}

{ #category : #'as yet unclassified' }
PhanideGDBEventHandler >> onConsoleOutput: aString [
]

{ #category : #events }
PhanideGDBEventHandler >> onExecBreakpointHitEvent: event [
	
]

{ #category : #events }
PhanideGDBEventHandler >> onExecExitedEvent: event [
	
]

{ #category : #events }
PhanideGDBEventHandler >> onExecRunningEvent: event [
]

{ #category : #events }
PhanideGDBEventHandler >> onExecStoppedEvent: event [
	
]

{ #category : #'as yet unclassified' }
PhanideGDBEventHandler >> onLogOutput: aString [
]

{ #category : #'as yet unclassified' }
PhanideGDBEventHandler >> onTargetErrorOutput: aString [
]

{ #category : #'as yet unclassified' }
PhanideGDBEventHandler >> onTargetOutput: aString [
]

{ #category : #'events-processing' }
PhanideGDBEventHandler >> processEvent: event [
	^ event accept: self
]
