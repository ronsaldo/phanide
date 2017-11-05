as yet unclassified
transitionToAll: targets onCharacterClass: aCharacterClass
	self addTransition: (PhanideNFAStateCharacterClassTransition new characterClass: aCharacterClass; targets: targets)