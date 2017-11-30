accessing
integerPart
	^ $- asParser optional , ($0 asParser / (($1 to: $9) asParser , #digit asParser star))