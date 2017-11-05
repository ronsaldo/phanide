as yet unclassified
styleText: aStringOrText withStyleTable: aStyleTable
	| text runs lastStop runCount |
	runs := RunArray new.
	lastStop := 0.
	self styleText: aStringOrText withBlock: [ :style :start :stop |
		runCount := start - (lastStop + 1).
		runCount ~= 0 ifTrue: [
			runs add: #() withOccurrences: runCount
		].
	
		runCount := stop - start + 1.
		runCount ~= 0 ifTrue: [
			runs add: (aStyleTable textAttributesForStyle: style) withOccurrences: runCount
		].
		lastStop := stop
	].

	text := aStringOrText asText.
	runCount := text size - runs size.
	runCount > 0 ifTrue: [ 
		runs add: #() withOccurrences: runCount
	].

	text setString: text string setRunsChecking: runs.
	^ text