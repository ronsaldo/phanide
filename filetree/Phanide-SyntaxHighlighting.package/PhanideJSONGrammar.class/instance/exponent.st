accessing
exponent
	^ ($e asParser / $E asParser), ($+ asParser / $- asParser) optional , #digit asParser plus