parsing
combineRules
	| acceptingStates initialState regex baseIndex defaultCharacterDetect defaultCharacterAccepting |
	combinedRegex := PhanideNFA new.
	acceptingStates := rules collectWithIndex: [ :r :i | combinedRegex newState ].

	initialState := combinedRegex newState.
	combinedRegex
		initial: initialState index;
		accepting: (acceptingStates collect: #index).
		
	rules doWithIndex: [ :rule :ruleIndex |
		regex := rule regex.
		baseIndex := combinedRegex addCopyingStatesWithBaseIndex: regex states.
		initialState transitionOnEpsilonTo: regex initial + baseIndex.
		regex accepting do: [ :index |
			(combinedRegex states at: index + baseIndex) transitionOnEpsilonTo: (acceptingStates at: ruleIndex) index
		]
	]. 

	"Add a default state"
	defaultCharacterDetect := combinedRegex newState.
	defaultCharacterAccepting := combinedRegex newState.
	combinedRegex accepting: (combinedRegex accepting , { defaultCharacterAccepting index }).
	defaultCharacterDetect transitionTo: defaultCharacterAccepting index onCharacterClass: PhanideNFACharacterClass any. 
	initialState transitionOnEpsilonTo: defaultCharacterDetect index.
	
	combinedRegex := combinedRegex simplified.