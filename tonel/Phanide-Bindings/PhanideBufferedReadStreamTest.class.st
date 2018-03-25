"
A PhanideBufferedReadStreamTest is a test class for testing the behavior of PhanideBufferedReadStream
"
Class {
	#name : #PhanideBufferedReadStreamTest,
	#superclass : #TestCase,
	#category : 'Phanide-Bindings-Tests'
}

{ #category : #tests }
PhanideBufferedReadStreamTest >> testBufferedStream [
	| rawStream stream |
	rawStream := ReadStream on: 'Hello World...'.
	stream := PhanideBufferedReadStream on: rawStream.
	self assert: stream peek equals: $H.
	self assert: stream next equals: $H.
	self assert: (stream next: 3) equals: 'ell'.
	self assert: stream next equals: $o.
	self assert: (stream next: 20) equals: ' World...'.
]
