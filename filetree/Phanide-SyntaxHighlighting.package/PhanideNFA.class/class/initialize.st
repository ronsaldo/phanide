initialization
initialize
	RepetitionTypeDictionary := Dictionary newFromPairs: #(
		$? optional
		$* star
		$+ plus
	).
	
	EscapeSequences := Dictionary newFromPairs: {
		'\*' . self character: $*.
		'\+' . self character: $+.
		'\?' . self character: $?.
		'\n' . self character: Character lf.
		'\r' . self character: Character cr.
		
		'\s' . (self characterClass: PhanideNFACharacterClass white).
		'\S' . (self characterClass: PhanideNFACharacterClass white negated).
	}.
	
	MetaCharacters := Dictionary newFromPairs: {
		$. . (self characterClass: PhanideNFACharacterClass dot)
	}.
