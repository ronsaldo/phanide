"
I am a rubric based text file editor for Phanide.
"
Class {
	#name : #PhanideBrowserRubricTextFileEditor,
	#superclass : #PhanideBrowserMorphFileEditor,
	#instVars : [
		'textModel'
	],
	#category : 'Phanide-Browser-UI'
}

{ #category : #testing }
PhanideBrowserRubricTextFileEditor class >> isFallbackEditorFor: aFileReference [
	[
		aFileReference contents 
	] on: Error do: [
		^ false
	].
	^ true
]

{ #category : #menu }
PhanideBrowserRubricTextFileEditor class >> menuKeyword [
	^ 'RubPlainTextMenu'
]

{ #category : #initialization }
PhanideBrowserRubricTextFileEditor >> createMorph [
	textModel := RubScrolledTextModel new.
	^ textModel newScrolledText
		color: Smalltalk ui theme backgroundColor;
		textColor: Smalltalk ui theme textColor;
		textFont: StandardFonts codeFont;
		tabWidth: (StandardFonts codeFont characterFormAt: Character space) advance x * 4;
		yourself.

]

{ #category : #debugging }
PhanideBrowserRubricTextFileEditor >> enableBreakpointAtLineIndex: lineIndex [
	| line startPosition endPosition conf breakpointHandle |
	line := morph paragraph lines at: lineIndex.	
	startPosition := line first.
	endPosition := line last.
	breakpointHandle := browser debuggerState
		getOrCreateBreakpointInFile: fileReference atLineIndex: lineIndex.
	breakpointHandle ifNil: [ ^ nil ].
	
	self makeTemporaryEditorPermanent.

	conf := RubConfigurationChange new.
	conf
		configurationBlock: [ :scrolledText |
		| r |
		r := PhanideRubBreakpointSetSegmentMorph from: startPosition to: endPosition.
		r 
			label: 'Breakpoint';
			iconBlock: [ :seg |
				breakpointHandle delete.
				seg delete
			];
			icon: (self iconNamed: #smallErrorIcon).
		scrolledText addSegment: r.
	].

	textModel announce: conf
]

{ #category : #debugging }
PhanideBrowserRubricTextFileEditor >> enableBreakpointOnClickEvent: anEvent morph: senderMorph [
	self enableBreakpointAtLineIndex: (senderMorph lineIndexForPoint: anEvent position)
]

{ #category : #'as yet unclassified' }
PhanideBrowserRubricTextFileEditor >> fileChanged [
	self flag: 'Support the different line endings natively'.
	textModel setText: (fileReference contents withSqueakLineEndings ).
	(PhanideStyler forFileReference: fileReference) ifNotNil: [ :styler |
		morph editingMode: (styler rubricEditingModeForFileReference: fileReference browserComponent: self).
	].
	morph hasUnacceptedEdits: false.
	self unsavedChanges: false.
]

{ #category : #'as yet unclassified' }
PhanideBrowserRubricTextFileEditor >> highlightLine: lineIndex forDebuggerStopReason: reason [
	| line startPosition endPosition conf |
	line := morph paragraph lines at: lineIndex.	
	startPosition := line first.
	endPosition := line last.

	conf := RubConfigurationChange new.
	conf configurationBlock: [ :scrolledText |
		scrolledText selectFrom: startPosition to: endPosition
	].

	textModel announce: conf.
	^ nil
]

{ #category : #initialization }
PhanideBrowserRubricTextFileEditor >> initializePresenter [
	self whenBuiltDo: [
		morph textArea setProperty: #processTabHere toValue: true.
		morph textArea announcer when: RubTextChanged send: #value: to: [ :ann | self makeDirty ].
		morph textArea announcer when: RubTextAcceptRequest send: #value: to: [ :ann | self save. ].
		morph lineNumbersRuler on: #click send: #enableBreakpointOnClickEvent:morph: to: self.
		morph textSegmentIconsRuler on: #click send: #enableBreakpointOnClickEvent:morph: to: self.
	]

]

{ #category : #api }
PhanideBrowserRubricTextFileEditor >> menuModel [
	^ morph textArea
]

{ #category : #actions }
PhanideBrowserRubricTextFileEditor >> saveInto: targetFileReference [
	| fileContent |
	fileContent := morph getText asString copy withUnixLineEndings.
	targetFileReference writeStreamDo: [ :s |
		s truncate; nextPutAll: fileContent
	].

]

{ #category : #initialization }
PhanideBrowserRubricTextFileEditor >> setupMorph [
	morph
		withLineNumbers;
		withTextSegmentIcons
]

{ #category : #'as yet unclassified' }
PhanideBrowserRubricTextFileEditor >> textMenu [
	^ self menu
]
