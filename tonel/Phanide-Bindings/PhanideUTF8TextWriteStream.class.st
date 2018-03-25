"
I am a stream that encodes text with UTF-8 and writes it into a decorated stream.
"
Class {
	#name : #PhanideUTF8TextWriteStream,
	#superclass : #Stream,
	#instVars : [
		'stream',
		'flushOnNewLines'
	],
	#category : 'Phanide-Bindings-Streams'
}

{ #category : #'instance creation' }
PhanideUTF8TextWriteStream class >> on: aStream [
	^ self basicNew stream: aStream
]

{ #category : #writing }
PhanideUTF8TextWriteStream >> cr [
	self nextPut: Character cr.
	flushOnNewLines ifTrue: [
		stream flush
	]
]

{ #category : #writing }
PhanideUTF8TextWriteStream >> crlf [
	self nextPutAll: String crlf.
	flushOnNewLines ifTrue: [
		stream flush
	]
]

{ #category : #accessing }
PhanideUTF8TextWriteStream >> flushOnNewLines [
	^ flushOnNewLines
]

{ #category : #accessing }
PhanideUTF8TextWriteStream >> flushOnNewLines: anObject [
	flushOnNewLines := anObject
]

{ #category : #writing }
PhanideUTF8TextWriteStream >> lf [
	self nextPut: Character lf.
	flushOnNewLines ifTrue: [
		stream flush
	]
]

{ #category : #accessing }
PhanideUTF8TextWriteStream >> nextPut: aCharacter [
	self primitiveNextPut: aCharacter.
	(flushOnNewLines and: [String crlf includes: aCharacter]) ifTrue: [
		stream flush
	]
	
]

{ #category : #accessing }
PhanideUTF8TextWriteStream >> nextPutAll: aCollection [
	| newLineHaveBeenSeen |
	newLineHaveBeenSeen := false.
	aCollection do: [ :element |
		newLineHaveBeenSeen ifFalse: [ 
			newLineHaveBeenSeen := (String crlf includes: element)
		].
		
		self primitiveNextPut: element
	].
	
	(newLineHaveBeenSeen and: [flushOnNewLines]) ifTrue: [
		stream flush
	]
]

{ #category : #accessing }
PhanideUTF8TextWriteStream >> primitiveNextPut: aCharacter [
	| codePoint |
	codePoint := aCharacter codePoint.
	codePoint <= 127 ifTrue: [
		stream nextPut: codePoint
	] ifFalse: [
		self halt.
	].
]

{ #category : #writing }
PhanideUTF8TextWriteStream >> space [
	self nextPut: Character space
]

{ #category : #accessing }
PhanideUTF8TextWriteStream >> stream [
	^ stream
]

{ #category : #accessing }
PhanideUTF8TextWriteStream >> stream: anObject [
	stream := anObject.
	flushOnNewLines := false.
]

{ #category : #writing }
PhanideUTF8TextWriteStream >> tab [
	self nextPut: Character tab
]
