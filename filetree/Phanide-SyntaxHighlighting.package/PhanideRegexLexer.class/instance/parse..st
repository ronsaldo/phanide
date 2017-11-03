parsing
parse: aDefinition
	| stateRules |
	states := Dictionary new.
	initialState := aDefinition first.
	aDefinition allButFirstDo: [ :stateDefinition |
		stateRules := PhanideRegexLexerStateRules parse: stateDefinition.
		states at: stateRules name put: stateRules
	].