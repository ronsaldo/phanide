constants
characterClass: aCollectionOfCharacter
	| result state accepting |
	result := self new.
	state := result newState.
	accepting := result newState.
	state transitionTo: accepting index onCharacterClass: aCollectionOfCharacter.
	^ result
		initial: 1;
		accepting: #(2);
		yourself