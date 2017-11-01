records
resultRecord
	^ super resultRecord ==> [ :tok |
		PhanideGDBResultRecord new
			token: tok first;
			resultClass: tok third;
			results: tok fourth;
			yourself
		]