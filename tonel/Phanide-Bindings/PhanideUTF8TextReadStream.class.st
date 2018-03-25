"
I am a stream that decodes UTF8 binary data from a decorated stream.
"
Class {
	#name : #PhanideUTF8TextReadStream,
	#superclass : #Stream,
	#instVars : [
		'stream',
		'peekValue'
	],
	#category : 'Phanide-Bindings-Streams'
}

{ #category : #'instance creation' }
PhanideUTF8TextReadStream class >> on: aStream [
	^ self basicNew stream: aStream
]

{ #category : #testing }
PhanideUTF8TextReadStream >> isBinary [
	^ false
]

{ #category : #accessing }
PhanideUTF8TextReadStream >> lines [
	| line |
	^ Array streamContents: [ :out |
		[ line := self nextLine ] whileNotNil: [ 
			out nextPut: line
		]
	]
]

{ #category : #accessing }
PhanideUTF8TextReadStream >> next [
	| result |
	result := self peek.
	peekValue := nil.
	^ result
]

{ #category : #accessing }
PhanideUTF8TextReadStream >> next: n [
	| result c |
	result := ByteString new: n.
	1 to: n do: [ :i |
		c := self next.
		c ifNil: [
			^ result copyFrom: 1 to: i - 1
		].
		result at: i put: c
	].

	^ result
]

{ #category : #accessing }
PhanideUTF8TextReadStream >> nextLine [
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
]

{ #category : #accessing }
PhanideUTF8TextReadStream >> peek [
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
]

{ #category : #accessing }
PhanideUTF8TextReadStream >> stream [
	^ stream
]

{ #category : #accessing }
PhanideUTF8TextReadStream >> stream: anObject [
	stream := anObject
]
