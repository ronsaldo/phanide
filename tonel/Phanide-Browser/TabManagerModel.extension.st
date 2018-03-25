Extension { #name : #TabManagerModel }

{ #category : #'*Phanide-Browser' }
TabManagerModel >> installPhanideComponentModel: aComponentModel [
	"Create the actual tab"
	| tab |
	tab := aComponentModel browser instantiate: PhanideTabModel.
	aComponentModel anchor: tab.
	tab model: aComponentModel.
	tab closeable: aComponentModel closeable.
	tab doubleClick: [ aComponentModel onAnchorDoubleClick ].
	tab okToCloseAction: [ aComponentModel okToClose ].

	"Add the tab to myself."
	self addTab: tab
]
