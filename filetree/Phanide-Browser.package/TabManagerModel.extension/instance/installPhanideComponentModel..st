*Phanide-Browser
installPhanideComponentModel: aComponentModel
	"Create the actual tab"
	| tab |
	tab := aComponentModel browser newTab.
	aComponentModel anchor: tab.
	tab model: aComponentModel.

	"Add the tab to myself."
	self addTab: tab