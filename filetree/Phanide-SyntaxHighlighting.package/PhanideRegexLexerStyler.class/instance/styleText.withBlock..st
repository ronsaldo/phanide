as yet unclassified
styleText: aString withBlock: aBlock
	^ self scanText: aString with: [ :rule :state :start :stop |
		aBlock value: (rule ifNil: [state defaultStyle ] ifNotNil: [rule style]) value: start value: stop
	]