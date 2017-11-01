accessing
cstring
	^ $" asParser , (($\ asParser , #any asParser) / $" asParser negate) star flatten, $" asParser