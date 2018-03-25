"
I represent a Phanide styler that uses a command stream that is built by a parser.
"
Class {
	#name : #PhanideCommandHighlighterStyler,
	#superclass : #PhanideStyler,
	#instVars : [
		'highlighter'
	],
	#category : 'Phanide-SyntaxHighlighting-Styler'
}

{ #category : #accessing }
PhanideCommandHighlighterStyler >> highlighter [
	^ highlighter
]

{ #category : #accessing }
PhanideCommandHighlighterStyler >> highlighter: anObject [
	highlighter := anObject
]

{ #category : #'as yet unclassified' }
PhanideCommandHighlighterStyler >> styleText: aText fromFileReference: aFileReference [
	| commands |
	commands := highlighter new parse: aText; commands.
	^ self styleText: aText withCommands: commands withStyleTable: PhanideSyntaxStyleTable current
]

{ #category : #'as yet unclassified' }
PhanideCommandHighlighterStyler >> styleText: aStringOrText withCommands: commands withStyleTable: styleTable [
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
]
