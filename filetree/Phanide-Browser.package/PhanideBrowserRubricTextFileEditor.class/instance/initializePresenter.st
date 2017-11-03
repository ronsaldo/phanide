initialization
initializePresenter
	self whenBuiltDo: [ 
		morph textArea announcer when: RubTextChanged send: #value: to: [ :ann | self makeDirty ].
		morph textArea announcer when: RubTextAccepted send: #value: to: [ :ann | self save ].
	]
