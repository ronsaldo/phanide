"
I represent an UI component in the Phanide browser user interface.
"
Class {
	#name : #PhanideBrowserComponent,
	#superclass : #ComposableModel,
	#instVars : [
		'browser',
		'anchor',
		'name',
		'label',
		'tab'
	],
	#category : 'Phanide-Browser-UI'
}

{ #category : #'instance creation' }
PhanideBrowserComponent class >> for: aBrowser [
	^ self basicNew initializeWithBrowser: aBrowser
]

{ #category : #testing }
PhanideBrowserComponent class >> isPermanentComponent [
	^ false
]

{ #category : #'as yet unclassified' }
PhanideBrowserComponent class >> specLayout [
	^ SpecLayout composed
]

{ #category : #accessing }
PhanideBrowserComponent >> anchor [
	^ anchor
]

{ #category : #accessing }
PhanideBrowserComponent >> anchor: anObject [
	anchor := anObject.
	self setupAnchor
]

{ #category : #accessing }
PhanideBrowserComponent >> browser [
	^ browser
]

{ #category : #api }
PhanideBrowserComponent >> closeable [
	^ false
]

{ #category : #accessing }
PhanideBrowserComponent >> defaultLabel [
	^ 'Untitled'
]

{ #category : #accessing }
PhanideBrowserComponent >> defaultName [
	^ self class name
]

{ #category : #'as yet unclassified' }
PhanideBrowserComponent >> destroyBrowserComponent [
	browser removeComponent: self.
	anchor ifNotNil: [ anchor destroyPhanideAnchorIn: browser ]
]

{ #category : #accessing }
PhanideBrowserComponent >> icon [
	^ nil
]

{ #category : #initialization }
PhanideBrowserComponent >> initializeWithBrowser: aBrowser [
	browser := aBrowser.
	self initialize.
]

{ #category : #'as yet unclassified' }
PhanideBrowserComponent >> installLocation [
	self subclassResponsibility
]

{ #category : #accessing }
PhanideBrowserComponent >> label [
	^ label ifNil: [ label := self defaultLabel ]
]

{ #category : #accessing }
PhanideBrowserComponent >> label: aNewLabel [
	anchor ifNotNil: [ anchor label: aNewLabel ].
	label := aNewLabel

]

{ #category : #'as yet unclassified' }
PhanideBrowserComponent >> makeActive [
	anchor ifNotNil: [ anchor makePhanideActiveAnchorIn: browser ]
]

{ #category : #api }
PhanideBrowserComponent >> menu [ 
		"Answer the menu to be presented "

	^ (PragmaMenuBuilder pragmaKeyword: self menuKeyword model: self) menu
]

{ #category : #accessing }
PhanideBrowserComponent >> name [
	^ name ifNil: [ name := self defaultName ]
]

{ #category : #accessing }
PhanideBrowserComponent >> name: aNewName [
	name ifNotNil: [ browser component: self renamedFrom: name into: aNewName ].
	name := aNewName
]

{ #category : #protocol }
PhanideBrowserComponent >> okToClose [
	browser removeClosedComponent: self.
	^ true
]

{ #category : #'as yet unclassified' }
PhanideBrowserComponent >> onAnchorDoubleClick [
]

{ #category : #accessing }
PhanideBrowserComponent >> setupAnchor [
	anchor label: self label.
	self icon ifNotNil: [ :icon | tab icon: icon ]
]

{ #category : #dialogs }
PhanideBrowserComponent >> textEntry: entryQuestion title: title completeAfter: initialText [
	| dialog |
	dialog := PhanideTextCompletionEntryDialogWindow new
			textFont: self theme textFont;
			title: title;
			text: entryQuestion;
			entryText: initialText.
	dialog textEditorMorph selectFrom: initialText size + 1 to: initialText size.
	UIManager default openModal: dialog.
	^ dialog entryText
]
