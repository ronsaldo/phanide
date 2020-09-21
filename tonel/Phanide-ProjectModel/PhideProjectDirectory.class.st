Class {
	#name : #PhideProjectDirectory,
	#superclass : #PhideProjectFileSystemElement,
	#instVars : [
		'children'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #accessing }
PhideProjectDirectory >> children [
	^ children ifNil: [ children := self loadChildren ]
]

{ #category : #accessing }
PhideProjectDirectory >> iconName [
	^ #glamorousFolder
]

{ #category : #'as yet unclassified' }
PhideProjectDirectory >> loadChildren [
	| newChildren |
	newChildren := OrderedCollection new.
	fileReference children do: [ :each |
		each asPhanideProjectElement ifNotNil: [ :converted |
			newChildren add: converted
		].
	].
	newChildren sort.
	^ newChildren
]

{ #category : #sorting }
PhideProjectDirectory >> sortPriority [
	^ 10
]
