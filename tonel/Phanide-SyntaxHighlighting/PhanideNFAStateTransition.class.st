"
I represent a non-deterministic state transition.
"
Class {
	#name : #PhanideNFAStateTransition,
	#superclass : #Object,
	#instVars : [
		'targets'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #testing }
PhanideNFAStateTransition >> acceptsCharacter: aCharacter [
	self subclassResponsibility
]

{ #category : #copying }
PhanideNFAStateTransition >> copyAddingBaseIndex: baseIndex [
	^ self copy targets: (targets collect: [:t | t + baseIndex])
]

{ #category : #copying }
PhanideNFAStateTransition >> copyWithRenameDictionary: renameDictionary [
	^ self copy targets: (targets collect: [:t | renameDictionary at: t]) flattened
]

{ #category : #testing }
PhanideNFAStateTransition >> isEpsilon [
	^ false
]

{ #category : #accessing }
PhanideNFAStateTransition >> targets [
	^ targets
]

{ #category : #accessing }
PhanideNFAStateTransition >> targets: anObject [
	targets := anObject
]
