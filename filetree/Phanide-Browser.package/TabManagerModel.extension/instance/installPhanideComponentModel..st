*Phanide-Browser
installPhanideComponentModel: aComponentModel
	"Create the actual tab"
	| tab |
	tab := aComponentModel browser newTab.
	aComponentModel anchor: tab.
	tab model: aComponentModel.
	tab phanideDoubleClick: [ aComponentModel onAnchorDoubleClick ].

	"Add the tab to myself."
	self addTab: tab