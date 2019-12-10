Class {
	#name : #PhanideBrowserGDBDebugger,
	#superclass : #PhanideBrowserDebugger,
	#instVars : [
		'gdb'
	],
	#category : #'Phanide-BrowserGDB'
}

{ #category : #testing }
PhanideBrowserGDBDebugger class >> isAvailable [
	^ LibPhanide isAvailable
]

{ #category : #initialization }
PhanideBrowserGDBDebugger >> initializeNewDebuggingSession [
	gdb := PhanideGDB new.
	gdb eventHandler: (PhanideBrowserGDBEventHandler new browser: browser).
	gdb start
]

{ #category : #initialization }
PhanideBrowserGDBDebugger >> runProgramLocally [
	gdb
		setupLocalIORedirection;
		execRun
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
]
