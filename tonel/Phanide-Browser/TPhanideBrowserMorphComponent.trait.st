Trait {
	#name : #TPhanideBrowserMorphComponent,
	#instVars : [
		'morph',
		'morphModel'
	],
	#category : #'Phanide-Browser-UI'
}

{ #category : #specs }
TPhanideBrowserMorphComponent classSide >> defaultSpec [
	^ self specLayout
		add: #morphModel
]

{ #category : #initialization }
TPhanideBrowserMorphComponent >> createMorph [
	self subclassResponsibility
]

{ #category : #initialization }
TPhanideBrowserMorphComponent >> initializeWidgets [
	morph := self createMorph.
	morph
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	morphModel := morph asSpecAdapter.
	self setupMorph.
]

{ #category : #accessing }
TPhanideBrowserMorphComponent >> morph [
	^ morph
]

{ #category : #accessing }
TPhanideBrowserMorphComponent >> morph: anObject [
	morph := anObject
]

{ #category : #accessing }
TPhanideBrowserMorphComponent >> morphModel [
	^ morphModel
]

{ #category : #initialization }
TPhanideBrowserMorphComponent >> setupMorph [
]
