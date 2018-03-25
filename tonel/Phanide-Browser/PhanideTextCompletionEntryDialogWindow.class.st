"
I am a text entry dialog that is used for completing a text.
"
Class {
	#name : #PhanideTextCompletionEntryDialogWindow,
	#superclass : #TextEntryDialogWindow,
	#category : 'Phanide-Browser-UI'
}

{ #category : #'instance creation' }
PhanideTextCompletionEntryDialogWindow >> newTextEditorMorph [
	"Answer a new text entry morph."
	^(self
		newTextEntryFor: self
		getText: #entryText
		setText: #entryText:
		getEnabled: nil
		help: nil)
		textMorph: PhanideTextMorphForFieldView new;
		acceptOnCR: false
]
