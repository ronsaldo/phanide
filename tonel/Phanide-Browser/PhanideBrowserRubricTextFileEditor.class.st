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

{ #category : #initialization }
PhanideBrowserRubricTextFileEditor >> initializePresenter [
	self whenBuiltDo: [
		morph textArea setProperty: #processTabHere toValue: true.
		morph textArea announcer when: RubTextChanged send: #value: to: [ :ann | self makeDirty ].
		morph textArea announcer when: RubTextAcceptRequest send: #value: to: [ :ann | self save. ].
		morph lineNumbersRuler on: #click send: #toggleBreakpointOnClickEvent:morph: to: self.
		morph textSegmentIconsRuler on: #click send: #toggleBreakpointOnClickEvent:morph: to: self.
	]

]

{ #category : #actions }
PhanideBrowserRubricTextFileEditor >> saveInto: targetFileReference [
	| fileContent |
	fileContent := morph getText asString withUnixLineEndings.
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
	^ super menu
]

{ #category : #debugging }
PhanideBrowserRubricTextFileEditor >> toggleBreakpointAtLineIndex: lineIndex [
	| newState |
	newState := browser toggleBreakpointInFile: fileReference atLineIndex: lineIndex.
]

{ #category : #debugging }
PhanideBrowserRubricTextFileEditor >> toggleBreakpointOnClickEvent: anEvent morph: senderMorph [
	self toggleBreakpointAtLineIndex: (senderMorph lineIndexForPoint: anEvent position)
]
