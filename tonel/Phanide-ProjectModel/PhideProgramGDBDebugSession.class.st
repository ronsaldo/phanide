Class {
	#name : #PhideProgramGDBDebugSession,
	#superclass : #PhideProgramDebugSession,
	#instVars : [
		'gdb'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #'debug actions' }
PhideProgramGDBDebugSession >> debugContinue [
	gdb ifNil: [ ^ self ].
	gdb execContinue
]

{ #category : #'debug actions' }
PhideProgramGDBDebugSession >> debugPause [
	gdb ifNil: [ ^ self ].
	gdb execInterrupt
]

{ #category : #'debug actions' }
PhideProgramGDBDebugSession >> debugStepInto [
	gdb ifNil: [ ^ self ].
	gdb execStep
]

{ #category : #'debug actions' }
PhideProgramGDBDebugSession >> debugStepOver [
	gdb ifNil: [ ^ self ].
	gdb execNext
]

{ #category : #'debug actions' }
PhideProgramGDBDebugSession >> debugStop [
	self terminate
]

{ #category : #accessing }
PhideProgramGDBDebugSession >> start [
	gdb := GDBMIClient new.
	gdb
		eventHandler: (PhideProgramGDBDebugSessionEventHandler new debugSession: self);
		start;
		setProgramFileAndSymbols: programFileName;
		setProgramArguments: commandLineArguments;
		workingDirectory: workingDirectory;
		execRun
]

{ #category : #actions }
PhideProgramGDBDebugSession >> terminate [
	gdb ifNil: [ ^ self ].
	gdb quit.
	gdb := nil
]
