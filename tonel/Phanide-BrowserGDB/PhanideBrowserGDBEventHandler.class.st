Class {
	#name : #PhanideBrowserGDBEventHandler,
	#superclass : #PhanideGDBEventHandler,
	#instVars : [
		'browser',
		'targetConsoleComponent'
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

{ #category : #accessing }
PhanideBrowserGDBEventHandler >> debugger [
	^ browser debuggerState currentDebugger
]

{ #category : #events }
PhanideBrowserGDBEventHandler >> notifyStopWithReason: reason atFrame: frame [
	browser debuggerState notifyDebugStopWithReason: reason file: frame file line: frame line pcAddress: frame addr pcFunction: frame func

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

{ #category : #'as yet unclassified' }
PhanideBrowserGDBEventHandler >> onTargetOutput: aString [
	self targetConsoleComponent ifNotNil: [ :comp |
		comp appendText: aString
	]
]

{ #category : #'as yet unclassified' }
PhanideBrowserGDBEventHandler >> targetConsoleComponent [
	^ targetConsoleComponent ifNil: [ targetConsoleComponent := browser getNamedComponent: #MainConsoleOutput ]
]
