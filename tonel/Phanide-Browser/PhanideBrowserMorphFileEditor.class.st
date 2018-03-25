"
I am a file editor that uses morphic directly presentation.
"
Class {
	#name : #PhanideBrowserMorphFileEditor,
	#superclass : #PhanideBrowserFileEditor,
	#instVars : [
		'morph',
		'morphModel'
	],
	#category : 'Phanide-Browser-UI'
}

{ #category : #specs }
PhanideBrowserMorphFileEditor class >> defaultSpec [
	^ self specLayout
		add: #morphModel
]

{ #category : #initialization }
PhanideBrowserMorphFileEditor >> createMorph [
	self subclassResponsibility
]

{ #category : #initialization }
PhanideBrowserMorphFileEditor >> initializeWidgets [
	morph := self createMorph.
	morph
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	morphModel := morph asSpecAdapter.
	self setupMorph.
]

{ #category : #accessing }
PhanideBrowserMorphFileEditor >> morph [
	^ morph
]

{ #category : #accessing }
PhanideBrowserMorphFileEditor >> morph: anObject [
	morph := anObject
]

{ #category : #accessing }
PhanideBrowserMorphFileEditor >> morphModel [
	^ morphModel
]

{ #category : #initialization }
PhanideBrowserMorphFileEditor >> setupMorph [
]
