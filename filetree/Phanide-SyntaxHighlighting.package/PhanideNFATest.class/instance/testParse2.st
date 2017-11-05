tests
testParse2
	| nfa |
	nfa := 'ab' asPhanideRegex.
	self assert: nfa states size equals: 3.
	self assert: nfa initial equals: 1.
	self assert: nfa accepting equals: #(3).
