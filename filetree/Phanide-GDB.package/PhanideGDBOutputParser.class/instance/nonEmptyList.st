accessing
nonEmptyList
	^ super nonEmptyList ==> [ :tok | { tok second } , (tok third collect: #second) ]