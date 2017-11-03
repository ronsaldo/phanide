as yet unclassified
scanStream: aStream with: aBlock
	| currentState currentRules |
	currentState := initialState.
	[ aStream atEnd ] whileFalse: [
		currentRules := states at: currentState.
		currentState := currentRules scanStream: aStream with: currentState doing: aBlock 
	]