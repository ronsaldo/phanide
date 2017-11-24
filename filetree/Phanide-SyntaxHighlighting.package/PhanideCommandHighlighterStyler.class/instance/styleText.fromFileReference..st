as yet unclassified
styleText: aText fromFileReference: aFileReference
	| commands |
	commands := highlighter new parse: aText; commands.
	^ self styleText: aText withCommands: commands withStyleTable: PhanideSyntaxStyleTable current