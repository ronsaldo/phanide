"
I am a ñexer that performs text styiling.

"
Class {
	#name : #PhanideRegexLexerStyler,
	#superclass : #PhanideRegexLexer,
	#instVars : [
		'defaultStyle'
	],
	#classVars : [
		'CStyler'
	],
	#category : 'Phanide-SyntaxHighlighting-Regex'
}

{ #category : #'as yet unclassified' }
PhanideRegexLexerStyler >> styleText: aStringOrText [
	^ self styleText: aStringOrText withStyleTable: PhanideSyntaxStyleTable current
]

{ #category : #'as yet unclassified' }
PhanideRegexLexerStyler >> styleText: aString withBlock: aBlock [
	^ self scanText: aString with: [ :rule :state :start :stop |
		aBlock value: (rule ifNil: [state defaultStyle ] ifNotNil: [rule style]) value: start value: stop
	]
]

{ #category : #'as yet unclassified' }
PhanideRegexLexerStyler >> styleText: aStringOrText withStyleTable: aStyleTable [
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
]
