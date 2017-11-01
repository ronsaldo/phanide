records
targetStreamRecord
	^ super targetStreamRecord ==> [ :tok | PhanideGDBTargetStreamRecord new value: tok second ]