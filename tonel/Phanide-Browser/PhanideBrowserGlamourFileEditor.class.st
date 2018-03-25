"
I am a file editor that uses a glamour presentation.
"
Class {
	#name : #PhanideBrowserGlamourFileEditor,
	#superclass : #PhanideBrowserFileEditor,
	#instVars : [
		'presentation',
		'presentationModel'
	],
	#category : 'Phanide-Browser-UI'
}

{ #category : #specs }
PhanideBrowserGlamourFileEditor class >> defaultSpec [
	^ self specLayout
		add: #presentationModel
]

{ #category : #initialization }
PhanideBrowserGlamourFileEditor >> buildGlamourPresentationAdapter [
	| morph |
	presentation := self createGlamourPresentation.
	morph := GLMMorphicRenderer new render: presentation.
	morph hResizing: #spaceFill.
	morph vResizing: #spaceFill.
	^ MorphicGenericAdapter morph: morph.
]

{ #category : #initialization }
PhanideBrowserGlamourFileEditor >> createGlamourPresentation [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PhanideBrowserGlamourFileEditor >> fileChanged [
	presentation update
]

{ #category : #initialization }
PhanideBrowserGlamourFileEditor >> initializePresenter [

]

{ #category : #initialization }
PhanideBrowserGlamourFileEditor >> initializeWidgets [
	presentationModel := self instantiate: GlamourPresentationModel.
	presentationModel presentation: self buildGlamourPresentationAdapter
]

{ #category : #accessing }
PhanideBrowserGlamourFileEditor >> presentation [
	^ presentation
]

{ #category : #accessing }
PhanideBrowserGlamourFileEditor >> presentationModel [
	^ presentationModel
]
