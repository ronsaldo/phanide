Class {
	#name : #PhideProjectBrowserComponent,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'projectBrowser',
		'projectBrowserAnchor',
		'browserComponentKey'
	],
	#category : #'Phanide-ProjectBrowser'
}

{ #category : #testing }
PhideProjectBrowserComponent class >> isPermanentComponent [
	^ false
]

{ #category : #adding }
PhideProjectBrowserComponent >> addToProjectBrowser: aProjectBrowser [
	self addToProjectBrowser: aProjectBrowser makeActive: false
]

{ #category : #adding }
PhideProjectBrowserComponent >> addToProjectBrowser: aProjectBrowser makeActive: makeActive [
	aProjectBrowser addBrowserComponent: self inLocation: self installLocation makeActive: makeActive
]

{ #category : #accessing }
PhideProjectBrowserComponent >> browserComponentKey [
	^ browserComponentKey
]

{ #category : #accessing }
PhideProjectBrowserComponent >> browserComponentKey: anObject [
	browserComponentKey := anObject
]

{ #category : #'initialize-release' }
PhideProjectBrowserComponent >> close [
	projectBrowserAnchor ifNotNil: [
		projectBrowserAnchor removeFromNotebook.
		projectBrowserAnchor := nil.
	].

	projectBrowser ifNotNil: [
		projectBrowser componentClosed: self.
		projectBrowser := nil
	].
]

{ #category : #accessing }
PhideProjectBrowserComponent >> installLocation [
	^ self subclassResponsibility
]

{ #category : #testing }
PhideProjectBrowserComponent >> isCloseable [
	^ false
]

{ #category : #accessing }
PhideProjectBrowserComponent >> projectBrowser [
	^ projectBrowser
]

{ #category : #accessing }
PhideProjectBrowserComponent >> projectBrowser: anObject [
	projectBrowser := anObject
]

{ #category : #accessing }
PhideProjectBrowserComponent >> projectBrowserAnchor [
	^ projectBrowserAnchor
]

{ #category : #accessing }
PhideProjectBrowserComponent >> projectBrowserAnchor: anObject [
	projectBrowserAnchor := anObject
]

{ #category : #'as yet unclassified' }
PhideProjectBrowserComponent >> titleChanged [
	projectBrowserAnchor ifNotNil: [ projectBrowserAnchor title: self title ]
]
