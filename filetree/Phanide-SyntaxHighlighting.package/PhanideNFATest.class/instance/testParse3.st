tests
testParse3
	| nfa |
	nfa := 'a?b' asPhanideRegex.
	self assert: nfa states size equals: 4.
	self assert: nfa initial equals: 4.
	self assert: nfa accepting equals: #(3).
