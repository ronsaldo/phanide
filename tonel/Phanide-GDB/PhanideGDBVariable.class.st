Class {
	#name : #PhanideGDBVariable,
	#superclass : #PhanideGDBHandle,
	#instVars : [
		'name',
		'arg',
		'type',
		'value'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #accessing }
PhanideGDBVariable >> arg [
	^ arg
]

{ #category : #accessing }
PhanideGDBVariable >> arg: anObject [
	arg := anObject
]

{ #category : #'as yet unclassified' }
PhanideGDBVariable >> constructFromResult: data [
	name := data at: #name ifAbsent: [ nil ].
	arg := data at: #arg ifAbsent: [ nil ].
	type := data at: #type ifAbsent: [ nil ].
	value := data at: #value ifAbsent: [ nil ].
]

{ #category : #accessing }
PhanideGDBVariable >> name [
	^ name
]

{ #category : #accessing }
PhanideGDBVariable >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PhanideGDBVariable >> type [
	^ type
]

{ #category : #accessing }
PhanideGDBVariable >> type: anObject [
	type := anObject
]

{ #category : #accessing }
PhanideGDBVariable >> value [
	^ value
]

{ #category : #accessing }
PhanideGDBVariable >> value: anObject [
	value := anObject
]
