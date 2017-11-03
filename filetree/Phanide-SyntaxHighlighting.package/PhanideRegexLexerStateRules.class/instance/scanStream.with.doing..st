as yet unclassified
scanStream: aStream with: startState doing: aBlock
	| startPosition abortPosition |
	startPosition := aStream position.
	[ aStream atEnd ] whileFalse: [ 
		abortPosition := aStream position.
		rules do: [ :rule |
			(rule matchStream: aStream) ifTrue: [
				abortPosition ~= startPosition ifTrue: [
					aStream position: abortPosition.
					aBlock value: nil value: self value: startPosition + 1 value: abortPosition.
					^ startState
				] ifFalse: [
					aBlock value: rule value: self value: startPosition + 1 value: aStream position.
					^ rule newState ifNil: [ startState ]
				]
			]
		].
	
		aStream position = abortPosition ifTrue: [
			aStream next
		].
	].
	
	aStream position ~= startPosition ifTrue: [
		aBlock value: nil value: self value: startPosition + 1 value: aStream position
	].
	^ startState