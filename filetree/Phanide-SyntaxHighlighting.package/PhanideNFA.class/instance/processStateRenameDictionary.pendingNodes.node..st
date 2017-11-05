simplification
processStateRenameDictionary: dictionary pendingNodes: pendingNodes node: pendingNode
	| targets |
	(pendingNodes includes: pendingNode) ifFalse: [ ^ dictionary at: pendingNode ].
	"We are assuming that there are no cycles here."
	pendingNodes remove: pendingNode.
	
	targets := Array streamContents: [ :out |
		(dictionary at: pendingNode) do: [:originalTarget |
			out nextPutAll: (self processStateRenameDictionary: dictionary pendingNodes: pendingNodes node: originalTarget)
		]
	].

	dictionary at: pendingNode put: targets.
	^ targets
