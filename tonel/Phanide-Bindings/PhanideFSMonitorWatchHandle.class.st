"
I represent a handle to something that is watched on the filesystem.
"
Class {
	#name : #PhanideFSMonitorWatchHandle,
	#superclass : #Object,
	#instVars : [
		'handle',
		'eventHandler'
	],
	#category : 'Phanide-Bindings-Driver'
}

{ #category : #accessing }
PhanideFSMonitorWatchHandle >> eventHandler [
	^ eventHandler
]

{ #category : #accessing }
PhanideFSMonitorWatchHandle >> eventHandler: anObject [
	eventHandler := anObject
]

{ #category : #accessing }
PhanideFSMonitorWatchHandle >> handle [
	^ handle
]

{ #category : #accessing }
PhanideFSMonitorWatchHandle >> handle: anObject [
	handle := anObject
]

{ #category : #'initialize-release' }
PhanideFSMonitorWatchHandle >> supportedEventMask [
	^ handle supportedEventMask
]
