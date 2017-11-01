records
notifyAsyncOutputRecord
	^ super notifyAsyncOutputRecord ==> [ :tok |
		PhanideGDBNotifyAsyncOutput new
			token: tok first;
			asyncClass: tok third;
			results: tok fourth;
			yourself
		]