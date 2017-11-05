as yet unclassified
scanStream: aStream with: startState doing: aBlock

	| finalState startPosition endPosition tokenStartPosition rule |
	startPosition := aStream position.
	[
		tokenStartPosition := aStream position.
		finalState := combinedRegex simulateStreamForPrefix: aStream.
		endPosition := aStream position.
	] doWhileFalse: [ finalState bestAcceptingState <= rules size or: [aStream atEnd]].

	startPosition ~= tokenStartPosition ifTrue: [
		aBlock value: nil value: self value: startPosition + 1 value: tokenStartPosition
	].

	(finalState bestAcceptingState <= rules size) ifTrue: [
		rule := rules at: finalState bestAcceptingState.
		aBlock value: rule value: self value: tokenStartPosition + 1 value: endPosition.
		^ rule newState ifNil: [ startState ]
	].

	^ startState