tests
testCondition
	| condition mutex entry leave |
	condition := PhanideConditionVariable new.
	mutex := Semaphore forMutualExclusion.
	entry := false.
	leave := false.
	[
		mutex critical: [ 
			entry := true.
			condition wait: mutex.
			leave := true.
		]
	] fork.

	(Delay forMilliseconds: 50) wait.
	self assert: entry.
	self deny: leave.
	condition signal.
	(Delay forMilliseconds: 50) wait.
	self assert: entry.
	