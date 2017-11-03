private
privateStyle: aText 
	| styledText |
	styler ifNil: [^ self ].
	styledText := styler styleText: aText asString onError: [  ].
	(styledText notNil and: [ styledText ~~ aText ]) ifTrue: [ 
		self flag: 'change only the runs array of the original text.'.
		aText setString: aText string setRunsChecking: styledText runs
	]