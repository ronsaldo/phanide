records
logStreamRecord
	^ super logStreamRecord ==> [ :tok | PhanideGDBLogStreamRecord new value: tok second ]