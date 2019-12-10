"
I am a gdb event handler that prints its output into the Transcript.
"
Class {
	#name : #PhanideGDBTranscriptOutputEventHandler,
	#superclass : #PhanideGDBEventHandler,
	#category : 'Phanide-GDB-FrontEnd'
}

{ #category : #'as yet unclassified' }
PhanideGDBTranscriptOutputEventHandler >> onConsoleOutput: aString [
	Transcript show: aString; cr.
]

{ #category : #'as yet unclassified' }
PhanideGDBTranscriptOutputEventHandler >> onLogOutput: aString [
	Transcript show: aString; cr.
]

{ #category : #'as yet unclassified' }
PhanideGDBTranscriptOutputEventHandler >> onTargetErrorOutput: aString [
	Transcript show: aString
]

{ #category : #'as yet unclassified' }
PhanideGDBTranscriptOutputEventHandler >> onTargetOutput: aString [
	Transcript show: aString
]
