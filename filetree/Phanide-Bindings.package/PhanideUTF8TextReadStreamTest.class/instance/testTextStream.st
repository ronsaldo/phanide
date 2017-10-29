tests
testTextStream
	| rawStream stream |
	rawStream := ReadStream on: ('Hello World...') asByteArray.
	stream := PhanideUTF8TextReadStream on: rawStream.
	self assert: stream peek equals: $H.
	self assert: stream next equals: $H.
	self assert: (stream next: 3) equals: 'ell'.
	self assert: stream next equals: $o.
	self assert: (stream next: 20) equals: ' World...'.