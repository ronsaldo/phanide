parsing
parse: aRuleDefinition
	regex := aRuleDefinition first asRegex.
	style := aRuleDefinition second.
	aRuleDefinition size >= 4 ifTrue: [ 
		self assert: aRuleDefinition third = #->.
		newState := aRuleDefinition fourth
	]