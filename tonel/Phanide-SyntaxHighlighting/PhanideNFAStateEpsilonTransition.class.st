"
I am a state transition on epsilon. I can be triggered on nothing.
"
Class {
	#name : #PhanideNFAStateEpsilonTransition,
	#superclass : #PhanideNFAStateTransition,
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #testing }
PhanideNFAStateEpsilonTransition >> isEpsilon [
	^ true
]

{ #category : #printing }
PhanideNFAStateEpsilonTransition >> printOn: aStream [
	aStream nextPutAll: 'epsilon -> '; print: targets
]
