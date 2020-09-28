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
			converted parent: self.
			newChildren add: converted
		].
	].
	newChildren sort.
	^ newChildren
]

{ #category : #'as yet unclassified' }
PhideProjectDirectory >> projectRootDirectoryElement [
	(parent isNil or: [parent isFileSystemElement not]) ifTrue: [ ^ self ].
	^ super projectRootDirectoryElement
]

{ #category : #sorting }
PhideProjectDirectory >> sortPriority [
	^ 10
]
