Class {
	#name : #PhideProgramGDBDebugSessionEventHandler,
	#superclass : #GDBEventHandler,
	#instVars : [
		'debugSession'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #accessing }
PhideProgramGDBDebugSessionEventHandler >> debugSession [
	^ debugSession
]

{ #category : #accessing }
PhideProgramGDBDebugSessionEventHandler >> debugSession: anObject [
	debugSession := anObject
]

{ #category : #events }
PhideProgramGDBDebugSessionEventHandler >> notifyProgramIsRunning [
	debugSession notifyProgramIsRunning
]

{ #category : #events }
PhideProgramGDBDebugSessionEventHandler >> notifyStopWithReason: reason atFrame: frame [
	debugSession notifyDebugStopWithReason: reason atFrame: (debugSession convertGDBFrame: frame)
]

{ #category : #'as yet unclassified' }
PhideProgramGDBDebugSessionEventHandler >> onConsoleOutput: aString [
	debugSession receiveDebuggerStdoutMessage: aString
]

{ #category : #events }
PhideProgramGDBDebugSessionEventHandler >> onExecBreakpointHitEvent: event [
	self notifyStopWithReason: 'Breakpoint hit' atFrame: event frame.
]

{ #category : #events }
PhideProgramGDBDebugSessionEventHandler >> onExecEndSteppingRange: event [
	self notifyStopWithReason: 'End stepping range' atFrame: event frame.

]

{ #category : #events }
PhideProgramGDBDebugSessionEventHandler >> onExecExitedEvent: event [
	debugSession ifNotNil: #programExited.

]

{ #category : #events }
PhideProgramGDBDebugSessionEventHandler >> onExecRunningEvent: event [
	self notifyProgramIsRunning

]

{ #category : #events }
PhideProgramGDBDebugSessionEventHandler >> onExecSignalReceived: event [
	self notifyStopWithReason: 'Signal received' atFrame: event frame.

]

{ #category : #'as yet unclassified' }
PhideProgramGDBDebugSessionEventHandler >> onLogOutput: aString [
	debugSession receiveDebuggerStdoutMessage: aString
]

{ #category : #'as yet unclassified' }
PhideProgramGDBDebugSessionEventHandler >> onTargetErrorOutput: aString [
	debugSession receiveStderrMessage: aString
]

{ #category : #'as yet unclassified' }
PhideProgramGDBDebugSessionEventHandler >> onTargetOutput: aString [
	debugSession receiveStdoutMessage: aString
]
