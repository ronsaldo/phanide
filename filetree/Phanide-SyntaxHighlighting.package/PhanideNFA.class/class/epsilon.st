constants
epsilon
	| result state |
	result := self new.
	state := result newState.
	^ result
		initial: 1;
		accepting: #(1);
		yourself