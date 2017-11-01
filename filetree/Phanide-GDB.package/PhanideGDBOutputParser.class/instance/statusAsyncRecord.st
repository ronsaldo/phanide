records
statusAsyncRecord
	^ super statusAsyncRecord ==> [ :tok |
		PhanideGDBStatusAsyncOutput new
			token: tok first;
			asyncClass: tok third;
			results: tok fourth;
			yourself
		]