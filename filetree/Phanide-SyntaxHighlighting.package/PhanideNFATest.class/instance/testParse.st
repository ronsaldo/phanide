tests
testParse
	| nfa |
	nfa := 'a' asPhanideRegex.
	self assert: nfa states size equals: 2.
	self assert: nfa initial equals: 1.
	self assert: nfa accepting equals: #(2).
