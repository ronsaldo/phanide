accessing
acceptingStates: anObject
	acceptingStates := anObject.
	acceptingStates ifNotEmpty: [ bestAcceptingState := acceptingStates min ]