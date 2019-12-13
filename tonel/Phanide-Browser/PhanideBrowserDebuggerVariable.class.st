Class {
	#name : #PhanideBrowserDebuggerVariable,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'value',
		'argumentIndex'
	],
	#category : #'Phanide-Browser-Debugging'
}

{ #category : #accessing }
PhanideBrowserDebuggerVariable >> argumentIndex [
	^ argumentIndex
]

{ #category : #accessing }
PhanideBrowserDebuggerVariable >> argumentIndex: anObject [
	argumentIndex := anObject
]

{ #category : #accessing }
PhanideBrowserDebuggerVariable >> name [
	^ name
]

{ #category : #accessing }
PhanideBrowserDebuggerVariable >> name: anObject [
	name := anObject
]

{ #category : #printing }
PhanideBrowserDebuggerVariable >> printOn: aStream [
	name ifNotNil: [ 
		aStream nextPutAll: name.
	].
	argumentIndex ifNotNil: [ 
		aStream nextPutAll: ' Argument: '; print: argumentIndex
	].

	type ifNotNil: [ 
		aStream nextPutAll: ' Type: '; print: type
	].

	value ifNotNil: [ 
		aStream nextPutAll: ' Value: '; print: value
	].
]

{ #category : #accessing }
PhanideBrowserDebuggerVariable >> type [
	^ type
]

{ #category : #accessing }
PhanideBrowserDebuggerVariable >> type: anObject [
	type := anObject
]

{ #category : #accessing }
PhanideBrowserDebuggerVariable >> value [
	^ value
]

{ #category : #accessing }
PhanideBrowserDebuggerVariable >> value: anObject [
	value := anObject
]
