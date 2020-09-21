Class {
	#name : #PhideProjectGroup,
	#superclass : #PhideProjectElement,
	#instVars : [
		'name',
		'children'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #accessing }
PhideProjectGroup >> children [
	^ children
]

{ #category : #accessing }
PhideProjectGroup >> children: anObject [
	children := anObject
]

{ #category : #accessing }
PhideProjectGroup >> name [
	^ name
]

{ #category : #accessing }
PhideProjectGroup >> name: anObject [
	name := anObject
]

{ #category : #sorting }
PhideProjectGroup >> sortPriority [
	^ 20
]
