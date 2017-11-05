accessing
characterRange
	^ super characterRange ==> [ :list | 
		PhanideNFACharacterClassRange new start: list first; stop: list third
	]