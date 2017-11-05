simplification
processStateRenameDictionary: dictionary pendingNodes: pendingNodes
	[ pendingNodes isEmpty ] whileFalse: [ 
		self processStateRenameDictionary: dictionary pendingNodes: pendingNodes node: pendingNodes anyOne.
	]