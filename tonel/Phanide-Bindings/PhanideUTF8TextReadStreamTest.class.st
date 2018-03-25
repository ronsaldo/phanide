"
A PhanideUTF8TextReadStreamTest is a test class for testing the behavior of PhanideUTF8TextReadStream
"
Class {
	#name : #PhanideUTF8TextReadStreamTest,
	#superclass : #TestCase,
	#category : 'Phanide-Bindings-Tests'
}

{ #category : #tests }
PhanideUTF8TextReadStreamTest >> testTextStream [
	| rawStream stream |
	rawStream := ReadStream on: ('Hello World...') asByteArray.
	stream := PhanideUTF8TextReadStream on: rawStream.
	self assert: stream peek equals: $H.
	self assert: stream next equals: $H.
	self assert: (stream next: 3) equals: 'ell'.
	self assert: stream next equals: $o.
	self assert: (stream next: 20) equals: ' World...'.
]
