constants
dot
	^ PhanideNFACharacterClassPredicate new name: '.'; block: [ :c | ((String crlf) includes: c) not ]