"
A PhanideNFATest is a test class for testing the behavior of PhanideNFA
"
Class {
	#name : #PhanideNFATest,
	#superclass : #TestCase,
	#category : 'Phanide-SyntaxHighlighting-Tests'
}

{ #category : #tests }
PhanideNFATest >> testParse [
	| nfa |
	nfa := 'a' asPhanideRegex.
	self assert: nfa states size equals: 2.
	self assert: nfa initial equals: 1.
	self assert: nfa accepting equals: #(2).

]

{ #category : #tests }
PhanideNFATest >> testParse2 [
	| nfa |
	nfa := 'ab' asPhanideRegex.
	self assert: nfa states size equals: 3.
	self assert: nfa initial equals: 1.
	self assert: nfa accepting equals: #(3).

]

{ #category : #tests }
PhanideNFATest >> testParse3 [
	| nfa |
	nfa := 'a?b' asPhanideRegex.
	self assert: nfa states size equals: 4.
	self assert: nfa initial equals: 4.
	self assert: nfa accepting equals: #(3).

]
