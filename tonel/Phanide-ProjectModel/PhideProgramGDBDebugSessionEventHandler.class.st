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

{ #category : #'as yet unclassified' }
PhideProgramGDBDebugSessionEventHandler >> onConsoleOutput: aString [
	debugSession receiveDebuggerStdoutMessage: aString
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
