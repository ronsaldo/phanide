Class {
	#name : #PhanideBrowserFileDebuggerState,
	#superclass : #Object,
	#instVars : [
		'fileReference',
		'perLineBreakpoints'
	],
	#category : #'Phanide-Browser-Debugging'
}

{ #category : #'instance creation' }
PhanideBrowserFileDebuggerState class >> for: aFileReference [
	^ self new fileReference: aFileReference
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileDebuggerState >> breakpointDeleted: breakpoint [
	perLineBreakpoints removeKey: breakpoint lineIndex ifAbsent: []
]

{ #category : #accessing }
PhanideBrowserFileDebuggerState >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideBrowserFileDebuggerState >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #'as yet unclassified' }
PhanideBrowserFileDebuggerState >> getOrCreateBreakpointAtLine: line [
	^ perLineBreakpoints at: line ifAbsentPut: [ PhanideBrowserDebuggerBreakpoint new
			fileDebuggingState: self;
			lineIndex: line;
			yourself ]
]

{ #category : #initialization }
PhanideBrowserFileDebuggerState >> initialize [
	super initialize.
	perLineBreakpoints := Dictionary new.
]
