records
execAsyncRecord
	^ super execAsyncRecord ==> [ :tok |
		PhanideGDBExecAsyncOutput new
			token: tok first;
			asyncClass: tok third;
			results: tok fourth;
			yourself
		]