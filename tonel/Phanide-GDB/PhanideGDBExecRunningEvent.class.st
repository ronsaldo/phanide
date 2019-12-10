Class {
	#name : #PhanideGDBExecRunningEvent,
	#superclass : #PhanideGDBExecEvent,
	#instVars : [
		'threadId'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #parsing }
PhanideGDBExecRunningEvent >> parseEventData: eventData [
	threadId := eventData at: 'thread-id' ifAbsent: [ nil ]
]

{ #category : #visiting }
PhanideGDBExecRunningEvent >> processWith: eventHandler [
	^ eventHandler onExecRunningEvent: self
]

{ #category : #accessing }
PhanideGDBExecRunningEvent >> threadId [
	^ threadId
]

{ #category : #accessing }
PhanideGDBExecRunningEvent >> threadId: anObject [
	threadId := anObject
]
