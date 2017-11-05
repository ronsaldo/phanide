accessing
transitionAt: aCharacter ifAbsentPut: aBlock
	| charCode result |
	charCode := aCharacter asInteger.
	charCode <= 127 ifTrue: [
		transitionArray ifNil: [ transitionArray := Array new: 128 withAll: EmptyObject].
		result := transitionArray at: charCode.
		^ result == EmptyObject ifFalse: [result] ifTrue: [
			transitionArray at: charCode put: aBlock value
		]
	] ifFalse: [
		transitionDictionary ifNil: [ transitionDictionary := Dictionary new ].
		^ transitionDictionary at: aCharacter ifAbsentPut: aBlock
	]