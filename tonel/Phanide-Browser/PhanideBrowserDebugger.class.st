Class {
	#name : #PhanideBrowserDebugger,
	#superclass : #Object,
	#instVars : [
		'browser'
	],
	#category : #'Phanide-Browser-Debugging'
}

{ #category : #'as yet unclassified' }
PhanideBrowserDebugger class >> findAvailableDebugger [
	self allSubclassesDo: [ :sc |
		sc isAvailable ifTrue: [ ^ sc new ]
	].

	^ nil
]

{ #category : #testing }
PhanideBrowserDebugger class >> isAvailable [
	^ false
]

{ #category : #accessing }
PhanideBrowserDebugger >> browser [
	^ browser
]

{ #category : #accessing }
PhanideBrowserDebugger >> browser: anObject [
	browser := anObject
]

{ #category : #initialization }
PhanideBrowserDebugger >> continue [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PhanideBrowserDebugger >> debuggerState [
	^ browser debuggerState
]

{ #category : #initialization }
PhanideBrowserDebugger >> initializeNewDebuggingSession [
	self subclassResponsibility
]

{ #category : #initialization }
PhanideBrowserDebugger >> pause [
	self subclassResponsibility
]

{ #category : #initialization }
PhanideBrowserDebugger >> runProgramLocally [
	self subclassResponsibility
]

{ #category : #initialization }
PhanideBrowserDebugger >> stepInto [
	self subclassResponsibility
]

{ #category : #initialization }
PhanideBrowserDebugger >> stepOver [
	self subclassResponsibility
]

{ #category : #accessing }
PhanideBrowserDebugger >> stop [
	self subclassResponsibility
]
