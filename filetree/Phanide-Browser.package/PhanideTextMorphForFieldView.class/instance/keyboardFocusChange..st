changed
keyboardFocusChange: aBoolean 
	"Restore the selection interval"
	| oldInterval |
	oldInterval := self editView selectionInterval.
	super keyboardFocusChange: aBoolean.
	self editView selectFrom: oldInterval first to: oldInterval last
