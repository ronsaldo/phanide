Class {
	#name : #PhideProjectElement,
	#superclass : #Object,
	#instVars : [
		'parent'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #comparing }
PhideProjectElement >> < other [
	self sortPriority = other sortPriority ifFalse: [ ^ self sortPriority < other sortPriority ].
	^ self name < other name
]

{ #category : #comparing }
PhideProjectElement >> <= other [
	self sortPriority = other sortPriority ifFalse: [ ^ self sortPriority >= other sortPriority ].
	^ self name <= other name
]

{ #category : #accessing }
PhideProjectElement >> children [
	^ #()
]

{ #category : #accessing }
PhideProjectElement >> iconName [
	^ nil
]

{ #category : #testing }
PhideProjectElement >> isFileSystemElement [
	^ false
]

{ #category : #accessing }
PhideProjectElement >> name [
	^ self subclassResponsibility
]

{ #category : #accessing }
PhideProjectElement >> parent [
	^ parent
]

{ #category : #accessing }
PhideProjectElement >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
PhideProjectElement >> project [
	^ parent project
]

{ #category : #sorting }
PhideProjectElement >> sortPriority [
	^ 0
]
