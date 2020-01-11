Extension { #name : #PhanideCommandHighlighterStyler }

{ #category : #'*Phanide-SyntaxHighlightingBloc' }
PhanideCommandHighlighterStyler >> styleBlocText: aText fromFileReference: fileReference withStyleTable: styleTable [
	| commands |
	commands := highlighter new parse: aText asString; commands.
	^ self styleBlocText: aText withCommands: commands withStyleTable: styleTable
]

{ #category : #'*Phanide-SyntaxHighlightingBloc' }
PhanideCommandHighlighterStyler >> styleBlocText: aBlText withCommands: commands withStyleTable: styleTable [
	commands do: [ :command |
		command executeOnBlocText: aBlText withStyleTable: styleTable
	].

	^ aBlText
]
