initialization
createGlamourPresentation
	^ self createTextPresentation
		display: [ self contents ];
		act: [:rub | self save ] 
			on: $s
			entitled: 'Save'