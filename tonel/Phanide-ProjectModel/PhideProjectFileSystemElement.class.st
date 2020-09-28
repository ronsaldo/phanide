Class {
	#name : #PhideProjectFileSystemElement,
	#superclass : #PhideProjectElement,
	#instVars : [
		'fileReference'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #'instance creation' }
PhideProjectFileSystemElement class >> for: aFileReference [
	^ self new initializeWith: aFileReference
]

{ #category : #accessing }
PhideProjectFileSystemElement >> fileReference [
	^ fileReference
]

{ #category : #initialization }
PhideProjectFileSystemElement >> initializeWith: aFileReference [
	super initialize.
	fileReference := aFileReference.
]

{ #category : #testing }
PhideProjectFileSystemElement >> isFileSystemElement [
	^ true
]

{ #category : #accessing }
PhideProjectFileSystemElement >> name [
	^ fileReference basename
]

{ #category : #'as yet unclassified' }
PhideProjectFileSystemElement >> projectRootDirectoryElement [
	^ parent projectRootDirectoryElement
]

{ #category : #'as yet unclassified' }
PhideProjectFileSystemElement >> projectRootRelativeFileReference [
	^ self fileReference relativeTo: self projectRootDirectoryElement fileReference
]