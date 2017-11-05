accessing
escapeSequence
	^ super escapeSequence ==> [ :c | PhanideNFA escapeSequence: c ]