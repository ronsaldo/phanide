Class {
	#name : #PhanideGDBExecStopInFrameEvent,
	#superclass : #PhanideGDBExecStoppedEvent,
	#instVars : [
		'frame'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #accessing }
PhanideGDBExecStopInFrameEvent >> frame [
	^ frame
]

{ #category : #accessing }
PhanideGDBExecStopInFrameEvent >> frame: anObject [
	frame := anObject
]

{ #category : #parsing }
PhanideGDBExecStopInFrameEvent >> parseEventData: eventData [
	super parseEventData: eventData.
	frame := PhanideGDBStackFrame for: gdb from: (eventData at: #frame).
	frame thread: (eventData at: 'thread-id') asInteger
]
