accessing
promptForCancel
	"Ask for the appropriate action to take when unaccepted contents
	would be overwritten."

	| choice |
	choice := UIManager default
		confirm: ('The contents of {1} has been modified.\What do you want to do?' translated withCRs format: { self fileName })
		trueChoice: 'Saved' translated
		falseChoice: 'Discard' translated
		cancelChoice: 'Cancel' translated
		default: nil.
	^ choice
	