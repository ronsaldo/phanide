accessing
nextLine
	| continue char result |
	result := ByteString streamContents: [ :out |
		continue := true.
		[ continue ] whileTrue: [ 
			char := self next.
			char = Character cr ifTrue: [ 
				self next.
				self peek = Character lf ifTrue: [ self next ].
				continue := false.
			] ifFalse: [
				char = Character lf ifTrue: [ 
					continue := false.
				] ifFalse: [
					char ifNil: [
						continue := false.
					] ifNotNil: [ 
						out nextPut: char
					]
				]
			]
		]
	].

	(char isNil and: [ result isEmpty ]) ifTrue: [ ^ nil ].
	^ result