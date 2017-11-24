accessing
children
	left ifNil: [ ^ #() ].
	^ { left . right }