Class {
	#name : #PhanideBrowserDebuggerPerFileState,
	#superclass : #Object,
	#instVars : [
		'fileReference',
		'perLineBreakpoints'
	],
	#category : #'Phanide-Browser-Debugging'
}

{ #category : #'instance creation' }
PhanideBrowserDebuggerPerFileState class >> for: aFileReference [
	^ self new fileReference: aFileReference
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebuggerPerFileState >> breakpointDeleted: breakpoint [
	perLineBreakpoints removeKey: breakpoint lineIndex ifAbsent: []
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebuggerPerFileState >> breakpoints [
	^ perLineBreakpoints values
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebuggerPerFileState >> breakpointsDo: aBlock [
	^ perLineBreakpoints valuesDo: aBlock
]

{ #category : #accessing }
PhanideBrowserDebuggerPerFileState >> fileReference [
	^ fileReference
]

{ #category : #accessing }
PhanideBrowserDebuggerPerFileState >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebuggerPerFileState >> getOrCreateBreakpointAtLine: line [
	^ perLineBreakpoints at: line ifAbsentPut: [ PhanideBrowserDebuggerBreakpoint new
			fileDebuggingState: self;
			lineIndex: line;
			yourself ]
]

{ #category : #initialization }
PhanideBrowserDebuggerPerFileState >> initialize [
	super initialize.
	perLineBreakpoints := Dictionary new.
]
