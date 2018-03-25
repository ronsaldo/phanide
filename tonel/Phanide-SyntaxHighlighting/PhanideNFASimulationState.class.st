"
I represent a state in the simulation of a non-determistic finite automata. I used to implement a caching strategy for the DFA version that is presented here: https://swtch.com/~rsc/regexp/regexp1.html
"
Class {
	#name : #PhanideNFASimulationState,
	#superclass : #Object,
	#instVars : [
		'acceptingStates',
		'activeStates',
		'transitionArray',
		'transitionDictionary',
		'mutex',
		'bestAcceptingState'
	],
	#classVars : [
		'EmptyObject',
		'RepetitionTypeDictionary'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #initialization }
PhanideNFASimulationState class >> initialize [
	EmptyObject := Object new.
]

{ #category : #accessing }
PhanideNFASimulationState >> acceptingStates [
	^ acceptingStates
]

{ #category : #accessing }
PhanideNFASimulationState >> acceptingStates: anObject [
	acceptingStates := anObject.
	acceptingStates ifNotEmpty: [ bestAcceptingState := acceptingStates min ]
]

{ #category : #accessing }
PhanideNFASimulationState >> activeStates [
	^ activeStates
]

{ #category : #accessing }
PhanideNFASimulationState >> activeStates: anObject [
	activeStates := anObject
]

{ #category : #accessing }
PhanideNFASimulationState >> bestAcceptingState [
	^ bestAcceptingState
]

{ #category : #initialization }
PhanideNFASimulationState >> initialize [
	super initialize.
	mutex := Semaphore forMutualExclusion.
	acceptingStates := #().
]

{ #category : #accessing }
PhanideNFASimulationState >> isAccepting [
	^ acceptingStates isNotEmpty
]

{ #category : #accessing }
PhanideNFASimulationState >> mutex [
	^ mutex
]

{ #category : #accessing }
PhanideNFASimulationState >> mutex: anObject [
	mutex := anObject
]

{ #category : #accessing }
PhanideNFASimulationState >> transitionAt: aCharacter ifAbsentPut: aBlock [
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
]
