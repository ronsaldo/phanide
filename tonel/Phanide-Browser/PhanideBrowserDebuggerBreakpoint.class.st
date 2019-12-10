Class {
	#name : #PhanideBrowserDebuggerBreakpoint,
	#superclass : #Object,
	#instVars : [
		'fileDebuggingState',
		'lineIndex'
	],
	#category : #'Phanide-Browser-Debugging'
}

{ #category : #'submorphs-add/remove' }
PhanideBrowserDebuggerBreakpoint >> delete [
	fileDebuggingState ifNotNil: [
		fileDebuggingState breakpointDeleted: self.
		fileDebuggingState := nil
	].
	
]

{ #category : #accessing }
PhanideBrowserDebuggerBreakpoint >> fileDebuggingState [
	^ fileDebuggingState
]

{ #category : #accessing }
PhanideBrowserDebuggerBreakpoint >> fileDebuggingState: anObject [
	fileDebuggingState := anObject
]

{ #category : #accessing }
PhanideBrowserDebuggerBreakpoint >> lineIndex [
	^ lineIndex
]

{ #category : #accessing }
PhanideBrowserDebuggerBreakpoint >> lineIndex: anObject [
	lineIndex := anObject
]
