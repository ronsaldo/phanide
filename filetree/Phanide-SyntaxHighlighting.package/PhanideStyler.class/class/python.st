stylers
python
	<styler>
	^ self styler: 'Python' extensions: #(py) regex: #(init
		(init foreground
			('"""' string -> multiLineString)

			('#.*' singleLineComment)
			
			('False' keyword)
			('None' keyword)
			('True' keyword)
			('and' keyword)
			('as' keyword)
			('assert' keyword)
			('break' keyword)
			('class' keyword)
			('continue' keyword)
			('def' keyword)
			('del' keyword)
			('elif' keyword)
			('else' keyword)
			('except' keyword)
			('finally' keyword)
			('for' keyword)
			('from' keyword)
			('global' keyword)
			('if' keyword)
			('import' keyword)
			('in' keyword)
			('is' keyword)
			('lambda' keyword)
			('nonlocal' keyword)
			('not' keyword)
			('or' keyword)
			('pass' keyword)
			('raise' keyword)
			('return' keyword)
			('try' keyword)
			('while' keyword)
			('with' keyword)
			('yield' keyword)
			
			('self' keyword)

			('''([^\\'']|\\.)*''' string)
			('"([^\\"]|\\.)*"' string)

			('@[A-Za-z_][A-Za-z_0-9]*' annotation)
			('[A-Za-z_][A-Za-z_0-9]*' identifier)
			('[0-9]+' number)
			('\s+' space)
		)
		
		(multiLineString string
			('"""' string -> init)
		)
	).