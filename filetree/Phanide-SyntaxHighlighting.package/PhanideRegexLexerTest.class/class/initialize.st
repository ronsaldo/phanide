initialization
initialize
	TestDefinition := #(init
		(init default
			('/\*' comment -> multiLineComment)
			('[A-Za-z_][A-Za-z_0-9]*' identifier)
			('[0-9]+' number)
			('\s+' space)
		)
	
		(multiLineComment comment
			('\*/' comment -> init)
		)
	).