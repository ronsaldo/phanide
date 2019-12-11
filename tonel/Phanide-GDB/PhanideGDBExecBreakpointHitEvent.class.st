Class {
	#name : #PhanideGDBExecBreakpointHitEvent,
	#superclass : #PhanideGDBExecStopInFrameEvent,
	#instVars : [
		'breakpointNumber'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #accessing }
PhanideGDBExecBreakpointHitEvent >> breakpointNumber [
	^ breakpointNumber
]

{ #category : #accessing }
PhanideGDBExecBreakpointHitEvent >> breakpointNumber: anObject [
	breakpointNumber := anObject
]

{ #category : #parsing }
PhanideGDBExecBreakpointHitEvent >> parseEventData: eventData [
	super parseEventData: eventData.
	breakpointNumber := eventData at: #bkptno.
]

{ #category : #visiting }
PhanideGDBExecBreakpointHitEvent >> processWith: eventHandler [
	^ eventHandler onExecBreakpointHitEvent: self
]
