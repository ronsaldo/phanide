accessing
nonEmptyList
	^ $[ asParser , value , ($, asParser , value) star, $] asParser