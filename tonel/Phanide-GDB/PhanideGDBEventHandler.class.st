"
I am event handler for events fired by gdb.
"
Class {
	#name : #PhanideGDBEventHandler,
	#superclass : #Object,
	#instVars : [
		'announcer'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #events }
PhanideGDBEventHandler >> dispatchEvent: event [
	UIManager default defer: [ self processEvent: event ]
]

{ #category : #'as yet unclassified' }
PhanideGDBEventHandler >> onConsoleOutput: aString [
]

{ #category : #events }
PhanideGDBEventHandler >> onExecBreakpointHitEvent: event [
	
]

{ #category : #events }
PhanideGDBEventHandler >> onExecEndSteppingRange: event [
	
]

{ #category : #events }
PhanideGDBEventHandler >> onExecExitedEvent: event [
	
]

{ #category : #events }
PhanideGDBEventHandler >> onExecRunningEvent: event [
]

{ #category : #events }
PhanideGDBEventHandler >> onExecSignalReceived: event [
	
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
	^ event processWith: self
]
