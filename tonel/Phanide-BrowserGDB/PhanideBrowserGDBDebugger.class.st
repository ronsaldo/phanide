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

{ #category : #initialization }
PhanideBrowserGDBDebugger >> continue [
	gdb execContinue
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

{ #category : #'as yet unclassified' }
PhanideBrowserGDBDebugger >> setupBreakpoint: breakpoint [
	breakpointHandles at: breakpoint ifAbsentPut: [
		gdb createBreakpointInFile: breakpoint fileReference fullName atLine: breakpoint lineIndex
	].
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
	gdb quit
]
