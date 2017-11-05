as yet unclassified
transitionOnEpsilonToAll: targets
	self addTransition: (PhanideNFAStateEpsilonTransition new targets: targets)