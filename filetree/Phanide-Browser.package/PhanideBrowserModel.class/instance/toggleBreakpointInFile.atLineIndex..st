as yet unclassified
toggleBreakpointInFile: fileReference atLineIndex: lineIndex
	fileReference ifNil: [ ^ false ].
	"TODO: Notify the debugger about the change."
	^ true