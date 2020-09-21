Class {
	#name : #PhideProject,
	#superclass : #Object,
	#instVars : [
		'topLevelElements'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #'as yet unclassified' }
PhideProject class >> forDirectory: aDirectoryNameOrFileReference [
	^ self new
		addTopLevelElement: aDirectoryNameOrFileReference asFileReference asPhanideProjectElement;
		yourself
]

{ #category : #adding }
PhideProject >> addTopLevelElement: anElement [
	topLevelElements add: anElement
]

{ #category : #initialization }
PhideProject >> initialize [
	super initialize.
	topLevelElements := OrderedCollection new.
]

{ #category : #testing }
PhideProject >> isEmpty [
	^ topLevelElements isEmpty
]

{ #category : #operations }
PhideProject >> openBrowser [
	^ (PhideProjectBrowser on: self) openWithSpec
]

{ #category : #initialization }
PhideProject >> topLevelElements [
	^ topLevelElements asArray
]
