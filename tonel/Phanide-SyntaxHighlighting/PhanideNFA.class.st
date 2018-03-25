"
Non-deterministi finite automata.

Thomson algorithm taken from: https://swtch.com/~rsc/regexp/regexp1.html

"
Class {
	#name : #PhanideNFA,
	#superclass : #Object,
	#instVars : [
		'initial',
		'accepting',
		'states',
		'simulationStateCacheMutex',
		'simulationStateCache',
		'initialSimulationState'
	],
	#classVars : [
		'EscapeSequences',
		'MetaCharacters',
		'RepetitionTypeDictionary'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #constants }
PhanideNFA class >> character: aCharacter [
	^ self characters: aCharacter asString
]

{ #category : #constants }
PhanideNFA class >> characterClass: aCollectionOfCharacter [
	| result state accepting |
	result := self new.
	state := result newState.
	accepting := result newState.
	state transitionTo: accepting index onCharacterClass: aCollectionOfCharacter.
	^ result
		initial: 1;
		accepting: #(2);
		yourself
]

{ #category : #constants }
PhanideNFA class >> characters: aCollectionOfCharacter [
	| result state accepting |
	result := self new.
	state := result newState.
	accepting := result newState.
	state transitionTo: accepting index onCharacters: aCollectionOfCharacter.
	^ result
		initial: 1;
		accepting: #(2);
		yourself
]

{ #category : #constants }
PhanideNFA class >> epsilon [
	| result state |
	result := self new.
	state := result newState.
	^ result
		initial: 1;
		accepting: #(1);
		yourself
]

{ #category : #initialization }
PhanideNFA class >> escapeSequence: sequence [
	EscapeSequences ifNil: [ self initialize ].
	^ EscapeSequences at: sequence ifAbsent: [ self character: sequence second ]

]

{ #category : #initialization }
PhanideNFA class >> initialize [
	RepetitionTypeDictionary := Dictionary newFromPairs: #(
		$? optional
		$* star
		$+ plus
	).
	
	EscapeSequences := Dictionary newFromPairs: {
		'\*' . self character: $*.
		'\+' . self character: $+.
		'\?' . self character: $?.
		'\n' . self character: Character lf.
		'\r' . self character: Character cr.
		
		'\s' . (self characterClass: PhanideNFACharacterClass white).
		'\S' . (self characterClass: PhanideNFACharacterClass white negated).
	}.
	
	MetaCharacters := Dictionary newFromPairs: {
		$. . (self characterClass: PhanideNFACharacterClass dot)
	}.

]

{ #category : #initialization }
PhanideNFA class >> metaCharacter: aChar [
	MetaCharacters ifNil: [ self initialize ].
	^ MetaCharacters at: aChar

]

{ #category : #composition }
PhanideNFA >> , nextNFA [
	| result firstBaseIndex secondBaseIndex |
	result := self class new.
	
	firstBaseIndex := result addCopyingStatesWithBaseIndex: states.
	secondBaseIndex := result addCopyingStatesWithBaseIndex: nextNFA states.

	result initial: initial + firstBaseIndex.
	result accepting: (nextNFA accepting collect: [ :ai | ai + secondBaseIndex]).
	result transitionStates: accepting withBase: firstBaseIndex onEpsilonTo: nextNFA initial + secondBaseIndex.
	^ result
]

{ #category : #composition }
PhanideNFA >> / alternativeNFA [
	| result firstBaseIndex secondBaseIndex resultInitial resultAccepting |
	result := self class new.

	resultInitial := result newState.
	resultAccepting := result newState.
		
	firstBaseIndex := result addCopyingStatesWithBaseIndex: states.
	secondBaseIndex := result addCopyingStatesWithBaseIndex: alternativeNFA states.
	
	resultInitial
		transitionOnEpsilonTo: initial + firstBaseIndex;
		transitionOnEpsilonTo: alternativeNFA initial + secondBaseIndex.

	result initial: resultInitial index.
	result accepting: {resultAccepting index}.
	result transitionStates: (accepting collect: [ :i | i + firstBaseIndex]) onEpsilonTo: resultAccepting index.
	result transitionStates: (alternativeNFA accepting collect: [:i | i + secondBaseIndex]) onEpsilonTo: resultAccepting index.
	^ result
]

{ #category : #accessing }
PhanideNFA >> accepting [
	^ accepting
]

{ #category : #accessing }
PhanideNFA >> accepting: anObject [
	accepting := anObject
]

{ #category : #adding }
PhanideNFA >> addCopyingStatesWithBaseIndex: aCollectionOfStates [
	| baseIndex |
	baseIndex := states size.
	aCollectionOfStates do: [ :state | self addState: (state copyAddingBaseIndex: baseIndex) ].
	^ baseIndex
]

{ #category : #adding }
PhanideNFA >> addState: state [
	states add: state.
	state index: states size.
	^ state
]

{ #category : #'automata simulation' }
PhanideNFA >> addState: targetState withEpsilonsInto: newStates [
	(newStates includes: targetState) ifTrue: [ ^ self ].
	newStates add: targetState.
	
	(states at: targetState) transitions do: [ :transition |
		transition isEpsilon ifTrue: [
			transition targets do: [ :t | self addState: t withEpsilonsInto: newStates ]
		]
	]
]

{ #category : #'automata simulation' }
PhanideNFA >> computeFromSimulationState: startState character: aCharacter [
	self flag: 'Check the performance cost of the mutex.'.
	"startState mutex critical: ["
		^ startState transitionAt: aCharacter ifAbsentPut: [
			self simulationStateForActiveStates: (self computeFromStates: startState activeStates character: aCharacter)
		]
	"]"
]

{ #category : #'automata simulation' }
PhanideNFA >> computeFromState: stateIndex character: character processedStates: processedStates into: newStates [
	| state |
	(processedStates includes: stateIndex) ifTrue: [ ^ self ].
	processedStates add: stateIndex.
	
	state := states at: stateIndex.
	state transitions do: [ :transition |
		"Follow the epsilon transitions."
		transition isEpsilon ifTrue: [
			transition targets do: [ :t |
				self computeFromState: t character: character processedStates: processedStates into: newStates
			]
		] ifFalse: [
			(transition acceptsCharacter: character) ifTrue: [
				transition targets do: [ :t | self addState: t withEpsilonsInto: newStates ]
			]
		]
	]
]

{ #category : #'automata simulation' }
PhanideNFA >> computeFromStates: startStates character: aCharacter [
	| newStates processedStates |
	newStates := Set new.
	processedStates := Set new.
	startStates do: [ :s |
		self computeFromState: s character: aCharacter processedStates: processedStates into: newStates.
	].

	^ newStates asArray sort
]

{ #category : #'automata simulation' }
PhanideNFA >> createSimulationStateForActiveStates: activeStates [
	| result |
	activeStates isEmptyOrNil ifTrue: [ ^ nil ].
	result := PhanideNFASimulationState new.
	result activeStates: activeStates.
	result acceptingStates: (accepting select: [:s | activeStates includes: s]).
	^ result
]

{ #category : #gt-extension }
PhanideNFA >> gtInspectorDescriptionIn: composite [
	"This is the most basic presentation showing the state of the object"
	<gtInspectorPresentationOrder: 5>
	^ composite text
		title: 'State Machine';
		display: [ self ]
]

{ #category : #accessing }
PhanideNFA >> initial [
	^ initial
]

{ #category : #accessing }
PhanideNFA >> initial: anObject [
	initial := anObject
]

{ #category : #'automata simulation' }
PhanideNFA >> initialSimulationState [
	^ initialSimulationState ifNil: [initialSimulationState := self simulationStateForActiveStates: {initial} ]
]

{ #category : #initialization }
PhanideNFA >> initialize [
	super initialize.
	states := OrderedCollection new.
	simulationStateCacheMutex := Semaphore forMutualExclusion. 
	simulationStateCache := Dictionary new.
]

{ #category : #'automata simulation' }
PhanideNFA >> matches: aString [
	^ self matchesStream: aString readStream
]

{ #category : #'automata simulation' }
PhanideNFA >> matchesStream: aStream [
	| finalState |
	finalState := self simulateStreamUntilEnd: aStream.
	^ finalState isNotNil and: [ finalState isAccepting ]
]

{ #category : #'automata simulation' }
PhanideNFA >> matchesStreamPrefix: aStream [
	| finalState |
	finalState := self simulateStreamForPrefix: aStream.
	^ finalState isNotNil and: [ finalState isAccepting ]
]

{ #category : #'instance creation' }
PhanideNFA >> newState [
	^ self addState: PhanideNFAState new
]

{ #category : #composition }
PhanideNFA >> optional [
	| result baseIndex resultInitial resultAccepting |
	result := self class new.

	baseIndex := result addCopyingStatesWithBaseIndex: states.
	resultInitial := result newState.
	resultAccepting := result newState.
	
	resultInitial
		transitionOnEpsilonTo: initial + baseIndex;
		transitionOnEpsilonTo: resultAccepting index.
	accepting do: [ :a | (result states at: a + baseIndex) transitionOnEpsilonTo: resultAccepting index ].
	result initial: resultInitial index;
		accepting: { resultAccepting index }.
	^ result
]

{ #category : #composition }
PhanideNFA >> plus [
	| result baseIndex resultAccepting resultContinue |
	result := self class new.

	baseIndex := result addCopyingStatesWithBaseIndex: states.
	resultContinue := result newState.
	resultAccepting := result newState.
	
	resultContinue
		transitionOnEpsilonTo: initial + baseIndex;
		transitionOnEpsilonTo: resultAccepting index.
	accepting do: [ :a | (result states at: a + baseIndex) transitionOnEpsilonTo: resultContinue index ].
	result initial: initial + baseIndex;
		accepting: { resultAccepting index }.
	^ result
]

{ #category : #printing }
PhanideNFA >> printOn: aStream [
	aStream print: initial; space; print: accepting; cr.
	states do: [ :state | aStream print: state ]
]

{ #category : #simplification }
PhanideNFA >> processStateRenameDictionary: dictionary pendingNodes: pendingNodes [
	[ pendingNodes isEmpty ] whileFalse: [ 
		self processStateRenameDictionary: dictionary pendingNodes: pendingNodes node: pendingNodes anyOne.
	]
]

{ #category : #simplification }
PhanideNFA >> processStateRenameDictionary: dictionary pendingNodes: pendingNodes node: pendingNode [
	| targets |
	(pendingNodes includes: pendingNode) ifFalse: [ ^ dictionary at: pendingNode ].
	"We are assuming that there are no cycles here."
	pendingNodes remove: pendingNode.
	
	targets := Array streamContents: [ :out |
		(dictionary at: pendingNode) do: [:originalTarget |
			out nextPutAll: (self processStateRenameDictionary: dictionary pendingNodes: pendingNodes node: originalTarget)
		]
	].

	dictionary at: pendingNode put: targets.
	^ targets

]

{ #category : #composition }
PhanideNFA >> repetitionOfType: aRepetitionType [
	^ self perform: (RepetitionTypeDictionary at: aRepetitionType)
]

{ #category : #simplification }
PhanideNFA >> simplified [
	| preservedStateCount stateRenameDictionary pendingNodes result newInitial |
	preservedStateCount := 0.
	stateRenameDictionary := Dictionary new.
	pendingNodes := Set new.
	states do: [ :state |
		state isOnlyEpsilon ifTrue: [ 
			stateRenameDictionary at: state index put: (state transitions collect: #targets) flattened.
			pendingNodes add: state index
		] ifFalse: [
			preservedStateCount := preservedStateCount + 1.
			stateRenameDictionary at: state index put: { preservedStateCount }.
		]
	].

	self processStateRenameDictionary: stateRenameDictionary pendingNodes: pendingNodes.
	result := self class new.
	states do: [ :state |
		state isOnlyEpsilon ifFalse: [
			result addState: (state copyWithRenameDictionary: stateRenameDictionary)
		]
	].
	result initial: (stateRenameDictionary at: initial).
	result initial size = 1 ifTrue: [
		result initial: result initial first.
	] ifFalse: [ 
		newInitial := result newState.
		newInitial transitionOnEpsilonToAll: result initial.
		result initial: newInitial index.
	].

	result accepting: (Array streamContents: [:out |
		accepting do: [ :as |
			out nextPutAll: (stateRenameDictionary at: as) 
		]
	]).
	^ result
]

{ #category : #'automata simulation' }
PhanideNFA >> simulateStreamForPrefix: aStream [
	| currentState c restorePosition bestResult bestAcceptingStateIndex |
	currentState := self initialSimulationState.
	restorePosition := aStream position.
	bestResult := nil.
	bestAcceptingStateIndex := nil.
	[aStream atEnd] whileFalse: [ 
		c := aStream peek.
		currentState := self computeFromSimulationState: currentState character: c.
		currentState ifNil: [
			aStream position: restorePosition.
			^ bestResult
		].
		aStream next.

		(currentState bestAcceptingState isNotNil and: [ bestAcceptingStateIndex isNil or: [currentState bestAcceptingState <= bestAcceptingStateIndex] ]) ifTrue: [
			bestResult := currentState.
			restorePosition := aStream position.
		].
	].
	aStream position: restorePosition.
	^ bestResult
]

{ #category : #'automata simulation' }
PhanideNFA >> simulateStreamUntilEnd: aStream [
	| currentState c |
	currentState := self simulationStateForActiveStates: {initial}.
	[aStream atEnd] whileFalse: [ 
		c := aStream next.
		currentState := self computeFromSimulationState: currentState character: c.
		currentState ifNil: [ ^ nil ].
	].
	^ currentState
]

{ #category : #'automata simulation' }
PhanideNFA >> simulationStateForActiveStates: activeStateSet [
	self flag: 'Check the performance cost of the mutex.'.
	"simulationStateCacheMutex critical: ["
		^ simulationStateCache at: activeStateSet ifAbsentPut: [
			self createSimulationStateForActiveStates: activeStateSet
		]
	"]"
]

{ #category : #composition }
PhanideNFA >> star [
	| result baseIndex resultInitial resultAccepting |
	result := self class new.

	baseIndex := result addCopyingStatesWithBaseIndex: states.
	resultInitial := result newState.
	resultAccepting := result newState.
	
	resultInitial
		transitionOnEpsilonTo: initial + baseIndex;
		transitionOnEpsilonTo: resultAccepting index.
	accepting do: [ :a | (result states at: a + baseIndex) transitionOnEpsilonTo: resultInitial index ].
	result initial: resultInitial index;
		accepting: { resultAccepting index }.
	^ result
]

{ #category : #accessing }
PhanideNFA >> states [
	^ states
]

{ #category : #simplification }
PhanideNFA >> transitionStates: stateIndices onEpsilonTo: targetState [
	self transitionStates: stateIndices withBase: 0 onEpsilonTo: targetState
]

{ #category : #simplification }
PhanideNFA >> transitionStates: stateIndices withBase: baseIndex onEpsilonTo: targetState [
	stateIndices do: [ :index | (states at: index + baseIndex) transitionOnEpsilonTo: targetState]
]
