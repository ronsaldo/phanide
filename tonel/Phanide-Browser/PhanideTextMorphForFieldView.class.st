"
I am a text entry morph that is used for completing a text.

Unlike my superclass, I do not alter the selection.
"
Class {
	#name : #PhanideTextMorphForFieldView,
	#superclass : #TextMorphForFieldView,
	#category : 'Phanide-Browser-UI'
}

{ #category : #changed }
PhanideTextMorphForFieldView >> keyboardFocusChange: aBoolean [ 
	"Restore the selection interval"
	| oldInterval |
	oldInterval := self editView selectionInterval.
	super keyboardFocusChange: aBoolean.
	self editView selectFrom: oldInterval first to: oldInterval last

]
