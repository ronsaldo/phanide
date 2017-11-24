as yet unclassified
styleText: aStringOrText withCommands: commands withStyleTable: styleTable
	| text  tree runs |
	tree := PhanideAttributesSegmentTree from: 1 to: aStringOrText size value: #().
	commands do: [ :command |
		command executeOnSegmentTree: tree withStyleTable: styleTable
	].
	
	runs := tree asRunArray.
	self assert: runs size = aStringOrText size.
	text := aStringOrText asText.
	text setString: text string setRunsChecking: runs.

	^ text