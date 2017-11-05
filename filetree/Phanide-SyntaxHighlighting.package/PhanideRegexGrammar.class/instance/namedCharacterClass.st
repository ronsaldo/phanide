accessing
namedCharacterClass
	^ '[:' asParser, #letter asParser plus flatten , ':]' asParser