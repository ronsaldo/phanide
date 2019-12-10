Class {
	#name : #PhanideBrowserDebuggerState,
	#superclass : #Object,
	#instVars : [
		'perFileDebuggingStates'
	],
	#category : #'Phanide-Browser-Debugging'
}

{ #category : #'as yet unclassified' }
PhanideBrowserDebuggerState >> getOrCreateBreakpointInFile: fileReference atLineIndex: lineIndex [
	| fileDebuggingState |
	fileDebuggingState := (self getOrCreateFileDebuggingState: fileReference).
	fileDebuggingState ifNil: [ ^ nil ].
	
	^ fileDebuggingState getOrCreateBreakpointAtLine: lineIndex
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebuggerState >> getOrCreateFileDebuggingState: fileReference [
	fileReference isAbsolute ifFalse: [ ^ self getOrCreateFileDebuggingState: fileReference asAbsolute ].
	^ perFileDebuggingStates at: fileReference ifAbsent: [ PhanideBrowserFileDebuggerState for: fileReference ]
]

{ #category : #initialization }
PhanideBrowserDebuggerState >> initialize [
	super initialize.
	perFileDebuggingStates := Dictionary new.
]
