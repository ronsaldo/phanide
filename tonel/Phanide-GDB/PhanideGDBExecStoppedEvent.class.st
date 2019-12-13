Class {
	#name : #PhanideGDBExecStoppedEvent,
	#superclass : #PhanideGDBExecEvent,
	#instVars : [
		'reason'
	],
	#classVars : [
		'ReasonEventClassMap'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #'instance creation' }
PhanideGDBExecStoppedEvent class >> for: gdb with: eventData [
	| reason |
	reason := eventData at: #reason.
	^ ((ReasonEventClassMap at: reason ifAbsent: [ self ]) for: gdb)
		parseEventData: eventData
]

{ #category : #'class initialization' }
PhanideGDBExecStoppedEvent class >> initialize [
	ReasonEventClassMap := Dictionary newFromPairs: {
		'breakpoint-hit' . PhanideGDBExecBreakpointHitEvent .
		'signal-received' . PhanideGDBExecSignalReceivedEvent .
		'end-stepping-range' . PhanideGDBExecEndSteppingRangeEvent .
		'exited' . PhanideGDBExecExitedEvent .
		'exited-normally' . PhanideGDBExecExitedEvent .
	}.
]

{ #category : #parsing }
PhanideGDBExecStoppedEvent >> parseEventData: eventData [
	reason := eventData at: #reason.
]

{ #category : #visiting }
PhanideGDBExecStoppedEvent >> processWith: eventHandler [
	^ eventHandler onExecStoppedEvent: self
]

{ #category : #accessing }
PhanideGDBExecStoppedEvent >> reason [
	^ reason
]

{ #category : #accessing }
PhanideGDBExecStoppedEvent >> reason: anObject [
	reason := anObject
]
