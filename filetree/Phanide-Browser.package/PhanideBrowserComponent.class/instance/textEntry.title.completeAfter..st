dialogs
textEntry: entryQuestion title: title completeAfter: initialText
	| dialog |
	dialog := PhanideTextCompletionEntryDialogWindow new
			textFont: self theme textFont;
			title: title;
			text: entryQuestion;
			entryText: initialText.
	dialog textEditorMorph selectFrom: initialText size + 1 to: initialText size.
	UIManager default openModal: dialog.
	^ dialog entryText