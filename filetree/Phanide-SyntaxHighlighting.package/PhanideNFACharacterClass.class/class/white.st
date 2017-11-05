constants
white
	^ PhanideNFACharacterClassPredicate new name: #white; block: [ :c | c isSeparator ]