"
I am a subclass of a Tab model. I add some missing required features.

"
Class {
	#name : #PhanideTabModel,
	#superclass : #TabPresenter,
	#instVars : [
		'okToCloseAction'
	],
	#category : #'Phanide-Browser-Spec'
}

{ #category : #'phanide anchor' }
PhanideTabModel >> destroyPhanideAnchorIn: aPhanideBrowser [
	owner removeTab: self
]

{ #category : #'api events' }
PhanideTabModel >> doubleClick: aBlock [
	self whenBuiltDo: [ 
		self widget ifNotNil: [:widget |
			widget widget ifNotNil: [ :morph |
				morph on: #doubleClick send: #value to: aBlock
			]
		]
	]

]

{ #category : #initialization }
PhanideTabModel >> initialize [
	super initialize.
	okToCloseAction := [ true ].
]

{ #category : #'phanide anchor' }
PhanideTabModel >> makePhanideActiveAnchorIn: aPhanideBrowser [
	owner widget ifNotNil: [:widget |
		widget widget ifNotNil: [ :morph |
			morph selectTabAt: (owner tabs indexOf: self)
		]
	]
]

{ #category : #protocol }
PhanideTabModel >> okToClose [
	^ okToCloseAction value
]

{ #category : #accessing }
PhanideTabModel >> okToCloseAction [
	^ okToCloseAction
]

{ #category : #accessing }
PhanideTabModel >> okToCloseAction: anObject [
	okToCloseAction := anObject
]

{ #category : #api }
PhanideTabModel >> presenter: aComposableModel [
	super presenter: aComposableModel
]
