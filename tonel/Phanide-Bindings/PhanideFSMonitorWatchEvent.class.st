"
I am an event for watched element using the low-level file system monitoring API.
"
Class {
	#name : #PhanideFSMonitorWatchEvent,
	#superclass : #Object,
	#instVars : [
		'handle',
		'name',
		'cookie',
		'mask'
	],
	#category : 'Phanide-Bindings-Driver'
}

{ #category : #accessing }
PhanideFSMonitorWatchEvent >> cookie [
	^ cookie
]

{ #category : #accessing }
PhanideFSMonitorWatchEvent >> cookie: anObject [
	cookie := anObject
]

{ #category : #accessing }
PhanideFSMonitorWatchEvent >> handle [
	^ handle
]

{ #category : #accessing }
PhanideFSMonitorWatchEvent >> handle: anObject [
	handle := anObject
]

{ #category : #accessing }
PhanideFSMonitorWatchEvent >> mask [
	^ mask
]

{ #category : #accessing }
PhanideFSMonitorWatchEvent >> mask: anObject [
	mask := anObject
]

{ #category : #accessing }
PhanideFSMonitorWatchEvent >> name [
	^ name
]

{ #category : #accessing }
PhanideFSMonitorWatchEvent >> name: anObject [
	name := anObject
]
