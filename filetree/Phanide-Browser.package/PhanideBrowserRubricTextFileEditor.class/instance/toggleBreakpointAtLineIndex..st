debugging
toggleBreakpointAtLineIndex: lineIndex
	| newState |
	newState := browser toggleBreakpointInFile: fileReference atLineIndex: lineIndex.