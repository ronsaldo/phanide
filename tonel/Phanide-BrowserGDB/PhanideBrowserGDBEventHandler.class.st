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
	^ browser debuggerState debugger
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
