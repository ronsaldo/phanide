Class {
	#name : #PhanideBrowserDebugConsoleTab,
	#superclass : #PhanideBrowserConsoleOutputTab,
	#category : #'Phanide-Browser-UI'
}

{ #category : #accessing }
PhanideBrowserDebugConsoleTab >> defaultLabel [
	^ 'Debugger Console'
]

{ #category : #accessing }
PhanideBrowserDebugConsoleTab >> defaultName [
	^ #DebugConsole
]

{ #category : #initialization }
PhanideBrowserDebugConsoleTab >> doIt [
	| doItText |
	doItText := morph textArea selection asString.
	doItText ifNotEmpty: [ self debuggerState doItCliCommand: doItText ]
]

{ #category : #initialization }
PhanideBrowserDebugConsoleTab >> initializePresenter [
	self on: $d meta do: [ self doIt ]
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebugConsoleTab >> installLocation [
	^ #rightBottomTabs
]
