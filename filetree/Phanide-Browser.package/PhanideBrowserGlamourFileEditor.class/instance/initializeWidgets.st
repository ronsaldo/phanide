initialization
initializeWidgets
	presentationModel := self instantiate: GlamourPresentationModel.
	presentationModel presentation: self buildGlamourPresentationAdapter