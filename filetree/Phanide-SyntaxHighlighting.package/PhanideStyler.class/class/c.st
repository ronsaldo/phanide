stylers
c
	<styler>
	^ self styler: 'C' extensions: #(c) regex: #(init
		(init foreground
			('/\*' multiLineComment -> multiLineComment)
			('//.*' singleLineComment)
			
			('\s*#\s*include\s<[^>]*>' preprocessor)
			('\s*#\s*[A-Za-z_][A-Za-z_0-9]*' preprocessor)

			('auto' keyword)
			('break' keyword)
			('case' keyword)
			('continue' keyword)
			('default' keyword)
			('do' keyword)
			('else' keyword)
			('enum' keyword)
			('extern' keyword)
			('for' keyword)
			('goto' keyword)
			('if' keyword)
			('inline' keyword)
			('return' keyword)
			('sizeof' keyword)
			('struct' keyword)
			('switch' keyword)
			('typedef' keyword)
			('union' keyword)
			('while' keyword)

			('static' keyword)
			('const' keyword)
			('register' keyword)
			('volatile' keyword)
			('restrict' keyword)
			('signed' keyword)
			('unsigned' keyword)

			('void' type)
			('char' type)
			('short' type)
			('int' type)
			('long' type)
			('float' type)
			('double' type)

			"C11 keywords"
			('_Alignas' keyword)
			('_Alignof' keyword)
			('_Atomic' keyword)
			('_Bool' type)
			('_Complex' type)
			('_Generic' keyword)
			('_Imaginary' type)
			('_Noreturn' keyword)
			('_Static_assert' keyword)
			('_Thread_local' keyword)

			('[A-Za-z_][A-Za-z_0-9]*_t\s' type)

			('''([^\\'']|\\.)*''' character)
			('"([^\\"]|\\.)*"' string)

			('[A-Za-z_][A-Za-z_0-9]*' identifier)
			('[0-9]*\.[0-9]+([eE][+\-]?[0-9]+)?[A-Za-z]*' number)
			('[0-9]+[A-Za-z]*' number)
			
			('[<>]=?' operator)
			('==' operator)
			('!=' operator)
			('[+-/*%&|^]=?' operator)
			('<<=' operator)
			('>>=' operator)
			('=' operator)
			('!' operator)
			('~' operator)
			('\?' operator)
			('::' operator)
			
			('\s+' space)
		)
	
		(multiLineComment multiLineComment
			('\*/' multiLineComment -> init)
		)
	).