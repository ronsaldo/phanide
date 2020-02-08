Class {
	#name : #PhanideBrowserGDBEventHandler,
	#superclass : #GDBEventHandler,
	#instVars : [
		'browser',
		'targetConsoleComponent',
		'debugConsoleComponent'
	],
	#category : #'Phanide-BrowserGDB'
}

{ #category : #accessing }
PhanideBrowserGDBEventHandler >> browser [
	^ browser
]

{ #category : #accessing }
PhanideBrowserGDBEventHandler >> browser: anObject [
	browser := anObject
]

{ #category : #'as yet unclassified' }
PhanideBrowserGDBEventHandler >> debugConsoleComponent [
	^ debugConsoleComponent ifNil: [ debugConsoleComponent := browser getNamedComponent: #DebugConsole ]
]

{ #category : #accessing }
PhanideBrowserGDBEventHandler >> debugger [
	^ browser debuggerState currentDebugger
]

{ #category : #events }
PhanideBrowserGDBEventHandler >> notifyProgramIsRunning [
	browser debuggerState notifyProgramIsRunning
]

{ #category : #events }
PhanideBrowserGDBEventHandler >> notifyStopWithReason: reason atFrame: frame [
	browser debuggerState notifyDebugStopWithReason: reason atFrame: (self debugger convertGDBFrame: frame)

]

{ #category : #'as yet unclassified' }
PhanideBrowserGDBEventHandler >> onConsoleOutput: aString [
	self debugConsoleComponent ifNotNil: [ :comp |
		comp appendText: aString withSqueakLineEndings
	]
]

{ #category : #events }
PhanideBrowserGDBEventHandler >> onExecBreakpointHitEvent: event [
	self notifyStopWithReason: 'Breakpoint hit' atFrame: event frame.

]

{ #category : #events }
PhanideBrowserGDBEventHandler >> onExecEndSteppingRange: event [
	self notifyStopWithReason: 'End stepping range' atFrame: event frame.

]

{ #category : #events }
PhanideBrowserGDBEventHandler >> onExecExitedEvent: event [
	self debugger ifNotNil: #programExited.

]

{ #category : #events }
PhanideBrowserGDBEventHandler >> onExecRunningEvent: event [
	self notifyProgramIsRunning

]

{ #category : #events }
PhanideBrowserGDBEventHandler >> onExecSignalReceived: event [
	self notifyStopWithReason: 'Signal received' atFrame: event frame.

]

{ #category : #'as yet unclassified' }
PhanideBrowserGDBEventHandler >> onLogOutput: aString [
	self debugConsoleComponent ifNotNil: [ :comp |
		comp appendText: aString withSqueakLineEndings
	]
]

{ #category : #'as yet unclassified' }
PhanideBrowserGDBEventHandler >> onTargetOutput: aString [
	self targetConsoleComponent ifNotNil: [ :comp |
		comp appendText: aString withSqueakLineEndings
	]
]

{ #category : #'as yet unclassified' }
PhanideBrowserGDBEventHandler >> targetConsoleComponent [
	^ targetConsoleComponent ifNil: [ targetConsoleComponent := browser getNamedComponent: #MainConsoleOutput ]
]
