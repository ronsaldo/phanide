Class {
	#name : #PhideDebugSessionStopFrame,
	#superclass : #Object,
	#instVars : [
		'reason',
		'frame'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #accessing }
PhideDebugSessionStopFrame >> frame [
	^ frame
]

{ #category : #accessing }
PhideDebugSessionStopFrame >> frame: anObject [
	frame := anObject
]

{ #category : #accessing }
PhideDebugSessionStopFrame >> reason [
	^ reason
]

{ #category : #accessing }
PhideDebugSessionStopFrame >> reason: anObject [
	reason := anObject
]
