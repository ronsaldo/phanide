Class {
	#name : #PhideProgramGDBDebugSession,
	#superclass : #PhideProgramDebugSession,
	#instVars : [
		'gdb'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #'debugging actions' }
PhideProgramGDBDebugSession >> convertGDBFrame: gdbFrame [
	^ PhideDebugSessionStackFrame new
		threadId: gdbFrame thread;
		level: gdbFrame level;
		address: gdbFrame addr;
		function: gdbFrame func;
		file: gdbFrame file;
		line: gdbFrame line;
		yourself
]

{ #category : #'debugging actions' }
PhideProgramGDBDebugSession >> convertGDBLocal: gdbLocal inStackFrame: stackFrame [
	^ PhideDebugSessionLocal new
		stackFrame: stackFrame;
		name: gdbLocal name;
		value: gdbLocal value;
		argumentIndex: gdbLocal arg;
		yourself
]

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

{ #category : #'as yet unclassified' }
PhideProgramGDBDebugSession >> localsInFrame: frame [
	^ (gdb getLocalsInThread: frame threadId frameLevel: frame level)
		collect: [ :each | self convertGDBLocal: each inStackFrame: frame ]
]

{ #category : #notifications }
PhideProgramGDBDebugSession >> notifyDebugStopWithReason: reason atFrame: frame [
	self currentThreadId: frame threadId.
	^ super notifyDebugStopWithReason: reason atFrame: frame
]

{ #category : #'as yet unclassified' }
PhideProgramGDBDebugSession >> stackTrace [
	gdb ifNil: [ ^ nil ].
	^ (gdb getStackTraceForThread: self currentThreadId) collect: [ :each | self convertGDBFrame: each ]
]

{ #category : #accessing }
PhideProgramGDBDebugSession >> start [
	gdb := GDBMIClient new.
	gdb
		eventHandler: (PhideProgramGDBDebugSessionEventHandler new debugSession: self);
		startProgramInPseudoTerminal: true;
		separateStdoutFromStderr: false;
		start;
		setProgramFileAndSymbols: programFileName;
		setProgramArguments: commandLineArguments;
		setWorkingDirectory: workingDirectory;
		execRun
]

{ #category : #actions }
PhideProgramGDBDebugSession >> terminate [
	gdb ifNil: [ ^ self ].
	gdb quit.
	gdb := nil
]
