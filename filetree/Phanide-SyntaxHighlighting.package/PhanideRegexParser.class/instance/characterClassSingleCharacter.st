accessing
characterClassSingleCharacter
	^ super characterClassSingleCharacter ==> [ :c | 
		PhanideNFACharacterClassCharacter new character: c
	]