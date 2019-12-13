Class {
	#name : #PhanideBrowserGDBDebugger,
	#superclass : #PhanideBrowserDebugger,
	#instVars : [
		'gdb',
		'breakpointHandles'
	],
	#category : #'Phanide-BrowserGDB'
}

{ #category : #testing }
PhanideBrowserGDBDebugger class >> isAvailable [
	^ LibPhanide isAvailable
]

{ #category : #'as yet unclassified' }
PhanideBrowserGDBDebugger >> breakpointCreated: breakpoint [
	breakpointHandles at: breakpoint ifAbsentPut: [
		gdb createBreakpointInFile: breakpoint fileReference fullName atLine: breakpoint lineIndex
	].
]

{ #category : #initialization }
PhanideBrowserGDBDebugger >> continue [
	gdb execContinue
]

{ #category : #'debugging actions' }
PhanideBrowserGDBDebugger >> convertGDBFrame: gdbFrame [
	^ PhanideBrowserDebuggerStackTraceFrame new
		threadId: gdbFrame thread;
		level: gdbFrame level;
		address: gdbFrame addr;
		function: gdbFrame func;
		file: gdbFrame file;
		line: gdbFrame line;
		yourself
]

{ #category : #'debugging actions' }
PhanideBrowserGDBDebugger >> convertGDBLocal: gdbLocal [
	^ PhanideBrowserDebuggerVariable new
		name: gdbLocal name;
		argumentIndex: gdbLocal arg;
		type: gdbLocal type;
		value: gdbLocal value;
		yourself
]

{ #category : #'debugging actions' }
PhanideBrowserGDBDebugger >> getLocals [
	| locals stackFrame |
	stackFrame := self debuggerState currentStackFrame ifNil: [ ^ #() ].
	locals := gdb getLocalsInThread: stackFrame threadId frameLevel: stackFrame level.
	^ locals collect: [ :local |
		self convertGDBLocal: local
	]
]

{ #category : #'debugging actions' }
PhanideBrowserGDBDebugger >> getStackTrace [
	| stackTrace |
	stackTrace := gdb getStackTraceForThread: (self debuggerState currentThread ifNil: [1]).
	^ stackTrace collect: [ :frame | self convertGDBFrame: frame ]
]

{ #category : #initialization }
PhanideBrowserGDBDebugger >> initialize [
	super initialize.
	breakpointHandles := Dictionary new.
]

{ #category : #initialization }
PhanideBrowserGDBDebugger >> initializeNewDebuggingSession [
	gdb := PhanideGDB new.
	gdb eventHandler: (PhanideBrowserGDBEventHandler new browser: browser).
	gdb start
]

{ #category : #initialization }
PhanideBrowserGDBDebugger >> pause [
	gdb execInterrupt
]

{ #category : #'as yet unclassified' }
PhanideBrowserGDBDebugger >> programExited [
	self stop
]

{ #category : #initialization }
PhanideBrowserGDBDebugger >> runProgramLocally [
	^ gdb execRun resultClass = #running
]

{ #category : #initialization }
PhanideBrowserGDBDebugger >> setProgramSettings: programSettings [
	gdb
		setProgramFileAndSymbols: programSettings programFileReference fullName;
		workingDirectory: programSettings workingDirectory fullName;
		setProgramArguments: programSettings arguments.
]

{ #category : #initialization }
PhanideBrowserGDBDebugger >> stepInto [
	gdb execStep
]

{ #category : #initialization }
PhanideBrowserGDBDebugger >> stepOver [
	gdb execNext
]

{ #category : #accessing }
PhanideBrowserGDBDebugger >> stop [
	gdb quit.
	self debuggerState debuggerFinished
]
