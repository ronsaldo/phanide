tests
testParser
	| records |
	records := self sample lines collect: [:line | PhanideGDBOutputParser parse: line].
	records do: [ :rec | self assert: rec isGDBOutputRecord ].
	self assert: records first isAsyncRecord. 
	self assert: records second isStreamRecord.
	self assert: (records at: 11) isEndRecord.
	self assert: (records at: 32) isResultRecord.
	self assert: records last isEndRecord.