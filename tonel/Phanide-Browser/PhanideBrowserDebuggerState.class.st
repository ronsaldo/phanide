Class {
	#name : #PhanideBrowserDebuggerState,
	#superclass : #Object,
	#instVars : [
		'browser',
		'currentStartupProgram',
		'perFileDebuggingStates',
		'perProgramSettings',
		'currentDebugger',
		'currentDebuggerStopHighlight',
		'currentThread',
		'currentStackFrame'
	],
	#category : #'Phanide-Browser-Debugging'
}

{ #category : #'as yet unclassified' }
PhanideBrowserDebuggerState >> breakpointCreated: breakpoint [
	currentDebugger ifNotNil: [ currentDebugger breakpointCreated: breakpoint ]
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebuggerState >> breakpointDestroyed: breakpoint [
	currentDebugger ifNotNil: [ currentDebugger breakpointDestroyed: breakpoint ]
]

{ #category : #accessing }
PhanideBrowserDebuggerState >> browser [
	^ browser
]

{ #category : #accessing }
PhanideBrowserDebuggerState >> browser: anObject [
	browser := anObject
]

{ #category : #'debugging actions' }
PhanideBrowserDebuggerState >> continueCurrentProgramExecution [
	currentDebugger ifNotNil: [ currentDebugger continue ]
]

{ #category : #accessing }
PhanideBrowserDebuggerState >> currentDebugger [
	^ currentDebugger
]

{ #category : #accessing }
PhanideBrowserDebuggerState >> currentStackFrame [
	^ currentStackFrame
]

{ #category : #accessing }
PhanideBrowserDebuggerState >> currentStackFrame: anObject [
	currentStackFrame := anObject.
	
	currentStackFrame ifNotNil: [
		currentStackFrame file ifNotNil: [ 
			self highlightFileForStackFrame: currentStackFrame
		] ifNil: [ 
		]
	].

	browser allComponentsDo: #notifyDebugStackFrameChanged.

]

{ #category : #accessing }
PhanideBrowserDebuggerState >> currentStartupProgram [
	^ currentStartupProgram
]

{ #category : #accessing }
PhanideBrowserDebuggerState >> currentStartupProgram: anObject [
	currentStartupProgram := anObject
]

{ #category : #accessing }
PhanideBrowserDebuggerState >> currentThread [
	^ currentThread
]

{ #category : #accessing }
PhanideBrowserDebuggerState >> currentThread: anObject [
	currentThread := anObject
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebuggerState >> debuggerFinished [
	currentDebugger := nil.
	browser allComponentsDo: #debuggerFinished
]

{ #category : #'debugging actions' }
PhanideBrowserDebuggerState >> getLocals [
	currentDebugger ifNil: [ ^ #() ].
	^ currentDebugger getLocals
]

{ #category : #breakpoints }
PhanideBrowserDebuggerState >> getOrCreateBreakpointInFile: fileReference atLineIndex: lineIndex [
	| fileDebuggingState |
	fileDebuggingState := (self getOrCreateFileDebuggingState: fileReference).
	fileDebuggingState ifNil: [ ^ nil ].
	
	^ fileDebuggingState getOrCreateBreakpointAtLine: lineIndex
]

{ #category : #breakpoints }
PhanideBrowserDebuggerState >> getOrCreateFileDebuggingState: fileReference [
	fileReference isAbsolute ifFalse: [ ^ self getOrCreateFileDebuggingState: fileReference asAbsolute ].
	^ perFileDebuggingStates at: fileReference ifAbsentPut: [ (PhanideBrowserDebuggerPerFileState for: fileReference)
		debuggingState: self;
		yourself ]
]

{ #category : #settings }
PhanideBrowserDebuggerState >> getOrCreatePerProgramSettingsForFileReference: aFileReference [
	aFileReference isAbsolute ifFalse: [ ^ self getOrCreatePerProgramSettingsForFileReference: aFileReference asAbsolute ].
	^ perProgramSettings at: aFileReference ifAbsentPut: [ PhanideBrowserDebuggerProgramSettings for: aFileReference ]
]

{ #category : #'debugging actions' }
PhanideBrowserDebuggerState >> getStackTrace [
	currentDebugger ifNil: [ ^ #() ].
	^ currentDebugger getStackTrace
]

{ #category : #accessing }
PhanideBrowserDebuggerState >> highlightFileForStackFrame: stackFrame [
	| fileReference |
	fileReference := stackFrame file asFileReference asAbsolute.
	fileReference exists ifTrue: [ 
		(browser openFileViewTemporarily: fileReference) ifNotNil: [ :fileView |
			currentDebuggerStopHighlight ifNotNil: [ currentDebuggerStopHighlight delete ].
			currentDebuggerStopHighlight := fileView highlightLine: stackFrame line forDebugStackFrame: stackFrame.
			^ self
		]
	]
]

{ #category : #initialization }
PhanideBrowserDebuggerState >> initialize [
	super initialize.
	perFileDebuggingStates := Dictionary new.
	perProgramSettings := Dictionary new.
	currentStartupProgram := nil.
	currentStackFrame := nil.
	currentThread := nil.
]

{ #category : #'debugger support' }
PhanideBrowserDebuggerState >> notifyDebugStopWithReason: reason atFrame: stackFrame [
	currentThread := stackFrame threadId.
	browser allComponentsDo: [ :comp |
		comp notifyDebugStopWithReason: reason atFrame: stackFrame
	].
	self currentStackFrame: stackFrame.
]

{ #category : #'debugger support' }
PhanideBrowserDebuggerState >> notifyProgramIsRunning [
	currentThread := nil.
	currentStackFrame := nil.
	browser allComponentsDo: [ :comp |
		comp notifyDebugProgramIsRunning
	].
]

{ #category : #'debugging actions' }
PhanideBrowserDebuggerState >> pauseCurrentProgramExecution [
	currentDebugger ifNotNil: [ currentDebugger pause ]
]

{ #category : #'debugging actions' }
PhanideBrowserDebuggerState >> runStartupProgramWithDebugger [
	currentStartupProgram ifNil: [ ^ self inform: 'A startup program is required to be run.' ].
	self startNewDebuggingSession.
	currentDebugger setProgramSettings: currentStartupProgram.
	self setupBreakpointsInDebugger.
	currentDebugger runProgramLocally.
]

{ #category : #initialization }
PhanideBrowserDebuggerState >> setCurrentStartupProgramForFileReference: aFileReference [
	| programSettings |
	programSettings := self getOrCreatePerProgramSettingsForFileReference: aFileReference.
	self currentStartupProgram: programSettings.
	^ programSettings
]

{ #category : #'debugging actions' }
PhanideBrowserDebuggerState >> setupBreakpointsInDebugger [
	perFileDebuggingStates valuesDo: [ :perFileState |
		perFileState breakpointsDo: [ :breakpoint |
			currentDebugger breakpointCreated: breakpoint.
		]
	]
]

{ #category : #'debugging actions' }
PhanideBrowserDebuggerState >> startNewDebuggingSession [
	self stopCurrentDebugger.
	
	currentDebugger := PhanideBrowserDebugger findAvailableDebugger
		ifNil: [ self error: 'Not valid debuggger is available.' ].
	currentDebugger
		browser: browser;
		initializeNewDebuggingSession.

]

{ #category : #'debugging actions' }
PhanideBrowserDebuggerState >> stepInto [
	currentDebugger ifNotNil: [ currentDebugger stepInto ]
]

{ #category : #'debugging actions' }
PhanideBrowserDebuggerState >> stepOver [
	currentDebugger ifNotNil: [ currentDebugger stepOver ]
]

{ #category : #'debugging actions' }
PhanideBrowserDebuggerState >> stopCurrentDebugger [
	currentDebugger ifNotNil: [ currentDebugger stop ].
	currentDebugger := nil.
	currentStackFrame := nil.
	currentThread := nil.
]
