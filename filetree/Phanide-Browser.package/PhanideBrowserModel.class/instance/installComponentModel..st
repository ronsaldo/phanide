as yet unclassified
installComponentModel: aComponentModel
	| anchorHolder |
	self registerNamedComponent: aComponentModel.

	anchorHolder := self perform: aComponentModel installLocation.
	anchorHolder installPhanideComponentModel: aComponentModel
