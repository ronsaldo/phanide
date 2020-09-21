Class {
	#name : #PhideProjectElement,
	#superclass : #Object,
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

{ #category : #accessing }
PhideProjectElement >> name [
	^ self subclassResponsibility
]

{ #category : #sorting }
PhideProjectElement >> sortPriority [
	^ 0
]
