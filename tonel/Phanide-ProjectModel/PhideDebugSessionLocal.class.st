Class {
	#name : #PhideDebugSessionLocal,
	#superclass : #Object,
	#instVars : [
		'stackFrame',
		'name',
		'value',
		'argumentIndex'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #accessing }
PhideDebugSessionLocal >> argumentIndex [
	^ argumentIndex
]

{ #category : #accessing }
PhideDebugSessionLocal >> argumentIndex: anObject [
	argumentIndex := anObject
]

{ #category : #accessing }
PhideDebugSessionLocal >> name [
	^ name
]

{ #category : #accessing }
PhideDebugSessionLocal >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PhideDebugSessionLocal >> stackFrame [
	^ stackFrame
]

{ #category : #accessing }
PhideDebugSessionLocal >> stackFrame: anObject [
	stackFrame := anObject
]

{ #category : #accessing }
PhideDebugSessionLocal >> value [
	^ value
]

{ #category : #accessing }
PhideDebugSessionLocal >> value: anObject [
	value := anObject
]
