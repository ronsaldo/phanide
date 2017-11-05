as yet unclassified
transitionOnEpsilonTo: target
	self assert: target isInteger.
	self transitionOnEpsilonToAll: {target}