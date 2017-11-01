visiting
visitResultRecord: record
	| tokenValue |
	record token ifNil: [ ^ self ].
	
	tokenValue := record token asInteger.
	self flag: 'TODO: Dispatch the pending records'