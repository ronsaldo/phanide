Class {
	#name : #PhanideBrowserDebuggerState,
	#superclass : #Object,
	#instVars : [
		'browser',
		'currentStartupProgram',
		'perFileDebuggingStates',
		'perProgramSettings',
		'currentDebugger',
		'currentDebuggerStopHighlight'
	],
	#category : #'Phanide-Browser-Debugging'
}

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
PhanideBrowserDebuggerState >> currentStartupProgram [
	^ currentStartupProgram
]

{ #category : #accessing }
PhanideBrowserDebuggerState >> currentStartupProgram: anObject [
	currentStartupProgram := anObject
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebuggerState >> debuggerFinished [
	currentDebugger := nil
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
	^ perFileDebuggingStates at: fileReference ifAbsentPut: [ PhanideBrowserDebuggerPerFileState for: fileReference ]
]

{ #category : #settings }
PhanideBrowserDebuggerState >> getOrCreatePerProgramSettingsForFileReference: aFileReference [
	aFileReference isAbsolute ifFalse: [ ^ self getOrCreatePerProgramSettingsForFileReference: aFileReference asAbsolute ].
	^ perProgramSettings at: aFileReference ifAbsentPut: [ PhanideBrowserDebuggerProgramSettings for: aFileReference ]
]

{ #category : #initialization }
PhanideBrowserDebuggerState >> initialize [
	super initialize.
	perFileDebuggingStates := Dictionary new.
	perProgramSettings := Dictionary new.
	currentStartupProgram := nil.
]

{ #category : #'debugger support' }
PhanideBrowserDebuggerState >> notifyDebugStopWithReason: reason file: file line: line pcAddress: pcAddress pcFunction: pcFunction [
	| fileReference |
	file ifNotNil: [
		fileReference := file asFileReference asAbsolute.
		fileReference exists ifTrue: [ 
			(browser openFileViewTemporarily: fileReference) ifNotNil: [ :fileView |
				currentDebuggerStopHighlight ifNotNil: [ currentDebuggerStopHighlight delete ].
				currentDebuggerStopHighlight := fileView highlightLine: line forDebuggerStopReason: reason.
				^ self
			]
		]
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
			currentDebugger setupBreakpoint: breakpoint.
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
	currentDebugger := nil
]
