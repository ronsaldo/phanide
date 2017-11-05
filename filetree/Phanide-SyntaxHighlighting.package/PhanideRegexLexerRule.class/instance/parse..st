parsing
parse: aRuleDefinition
	regex := aRuleDefinition first asPhanideRegex.
	style := aRuleDefinition second.
	aRuleDefinition size >= 4 ifTrue: [ 
		self assert: aRuleDefinition third = #->.
		newState := aRuleDefinition fourth
	]