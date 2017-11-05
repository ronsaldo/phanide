constants
characters: aCollectionOfCharacter
	| result state accepting |
	result := self new.
	state := result newState.
	accepting := result newState.
	state transitionTo: accepting index onCharacters: aCollectionOfCharacter.
	^ result
		initial: 1;
		accepting: #(2);
		yourself