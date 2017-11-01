initialization
initialize
	CScapeCharacter := Dictionary newFromPairs: { 
		$a . 16r07 asCharacter.
		$b . 16r08 asCharacter.
		$f . 16r0c asCharacter.
		$n . Character lf.
		$r . Character cr.
		$t . Character tab.
		$v . 16r0b asCharacter.
		$' . $'.
		$" . $".
		$\ . $\.
	}.
	