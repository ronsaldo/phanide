stylers
cpp
	<styler>
	^ self styler: 'C++' extensions: #(cpp h hpp inc) regex: #(init
		(init foreground
			('/\*' multiLineComment -> multiLineComment)
			('//.*' singleLineComment)
			
			('\s*#\s*include\s<[^>]*>' preprocessor)
			('\s*#\s*(define|if|ifdef|ifndef|else|endif|pragma|line)' preprocessor)

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

			('[A-Za-z_][A-Za-z_0-9]*_t' type)

			('''([^\\"]|\\.)*''' character)
			('"([^\\"]|\\.)*"' string)

			('[A-Za-z_][A-Za-z_0-9]*' identifier)
			('[0-9]+' number)
			('\s+' space)
		)
	
		(multiLineComment multiLineComment
			('\*/' multiLineComment -> init)
		)
	).