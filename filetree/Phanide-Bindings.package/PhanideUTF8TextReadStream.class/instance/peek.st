accessing
peek
	| b |
	peekValue ifNotNil: [ ^ peekValue ].
	
	b := stream next.
	b ifNil: [ ^ nil ].
	
	b <= 127 ifTrue: [
		peekValue := b asCharacter 
	] ifFalse: [
		self flag: 'TODO: Decode the UTF-8 character.'.
		self halt.
	].

	^ peekValue