as yet unclassified
transitionToAll: targets onCharacters: aCollectionOfCharacters
	self addTransition: (PhanideNFAStateCharactersTransition new characters: aCollectionOfCharacters; targets: targets)