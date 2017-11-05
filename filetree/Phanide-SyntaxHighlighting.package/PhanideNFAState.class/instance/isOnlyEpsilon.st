testing
isOnlyEpsilon
	transitions ifEmpty: [ ^ false ].
	^ transitions detect: [:x | x isEpsilon not] ifFound: [ false ] ifNone: [ true ]