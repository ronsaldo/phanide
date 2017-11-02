as yet unclassified
destroyBrowserComponent
	browser removeComponent: self.
	anchor ifNotNil: [ anchor destroyPhanideAnchorIn: browser ]