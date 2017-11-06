debugging
toggleBreakpointOnClickEvent: anEvent morph: senderMorph
	self toggleBreakpointAtLineIndex: (senderMorph lineIndexForPoint: anEvent position)