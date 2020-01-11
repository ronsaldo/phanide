"
I represent a generic phanide styler.
"
Class {
	#name : #PhanideStyler,
	#superclass : #Object,
	#instVars : [
		'name',
		'extensions'
	],
	#classVars : [
		'StylerDictionary',
		'StylerExtensionDictionary'
	],
	#category : #'Phanide-SyntaxHighlighting-Styler'
}

{ #category : #stylers }
PhanideStyler class >> c [
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
]

{ #category : #stylers }
PhanideStyler class >> cpp [
	<styler>
	^ self styler: 'C++' extensions: #(cpp h hpp inc) regex: #(init
		(init foreground
			('/\*' multiLineComment -> multiLineComment)
			('//.*' singleLineComment)
			
			('\s*#\s*include\s<[^>]*>' preprocessor)
			('\s*#\s*[A-Za-z_][A-Za-z_0-9]*' preprocessor)

			('alignas' keyword)
			('alignof' keyword)
			('auto' keyword)
			('break' keyword)
			('case' keyword)
			('class' keyword)
			('const_cast' keyword)
			('continue' keyword)
			('decltype' keyword)
			('default' keyword)
			('delete' keyword)
			('do' keyword)
			('dynamic_cast' keyword)
			('else' keyword)
			('enum' keyword)
			('explicit' keyword)
			('export' keyword)
			('extern' keyword)
			('false' keyword)
			('friend' keyword)
			('for' keyword)
			('goto' keyword)
			('if' keyword)
			('inline' keyword)
			('mutable' keyword)
			('namespace' keyword)
			('new' keyword)
			('noexcept' keyword)
			('operator' keyword)
			('private' keyword)
			('protected' keyword)
			('public' keyword)
			('reinterpret_cast' keyword)
			('return' keyword)
			('sizeof' keyword)
			('static_assert' keyword)
			('static_cast' keyword)			
			('struct' keyword)
			('switch' keyword)
			('template' keyword)
			('this' keyword)
			('throw' keyword)
			('true' keyword)
			('try' keyword)
			('typeid' keyword)
			('typename' keyword)
			('typedef' keyword)
			('union' keyword)
			('using' keyword)
			('virtual' keyword)
			('while' keyword)

			('static' keyword)
			('const' keyword)
			('constexpr' keyword)
			('register' keyword)
			('volatile' keyword)
			('restrict' keyword)
			('signed' keyword)
			('thread_local' keyword)
			('unsigned' keyword)

			('void' type)
			('bool' type)
			('char' type)
			('short' type)
			('int' type)
			('long' type)
			('float' type)
			('double' type)

			('[A-Za-z_][A-Za-z_0-9]*_t' type)

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
]

{ #category : #stylers }
PhanideStyler class >> erlang [
	<styler>
	^ self styler: 'Erlang' extensions: #(erl hrl) regex: #(init
		(init foreground
			('%.*' singleLineComment)
			
			('-[a-z]+' preprocessor)
			('?[_A-Za-z][_A-Za-z0-9]*' preprocessor)

			('after' keyword)
			('begin' keyword)
			('case' keyword)
			('catch' keyword)
			('cond' keyword)
			('end' keyword)
			('fun' keyword)
			('if' keyword)
			('let' keyword)
			('of' keyword)
			('query' keyword)
			('receive' keyword)
			('when' keyword)

			"Binary format spec"
			('/[a-z]+(-[a-z]+)+' annotation)

			"Call"
			('''([^\\'']|\\.)*''\(' callBracket)
			('[a-z][A-Za-z_0-9]*\(' callBracket)
			('(' callBracket)
			('\)' callBracket)
			
			"Record name"
			('#[a-z_][a-zA-Z_0-9]*' struct)

			"Module name"
			('''([^\\'']|\\.)*'':' module)
			('[a-z][A-Za-z_0-9]*:' module)
			
			"Atom"
			('''([^\\'']|\\.)*''' type)
			('[a-z][A-Za-z_0-9]*' type)
						
			('"([^\\"]|\\.)*"' string)

			('_[A-Za-z_0-9]*' patternDontCare)
			('[A-Z_][A-Za-z_0-9]*' identifier)

			('[0-9]*\.[0-9]+([eE][+\-]?[0-9]+)?[A-Za-z]*' number)
			('[0-9]+[A-Za-z]*' number)


			"Boolean operators"
			(not operator)
			(and operator)			
			(or operator)
			(xor operator)

			"Short circuit"
			(orelse operator)
			(andalso operator)

			"Comparison"
			('==' operator)
			('/=' operator)
			('=<' operator)
			('>=' operator)
			('=:=' operator)
			('=/=' operator)
			('=' operator)
			('<' operator)
			('>' operator)

			"Message send"
			('!' operator)

			"Arithmetic"
			(+ operator)	
			(- operator)	
			(* operator)		
			(/ operator)		
			(div operator)
			(rem operator)
			(band operator)	
			(bnot operator)		
			(bor operator)
			(bsl operator)
			(bxor operator)
			
			"List operations"
			(++ operator)
			(-- operator)
			
			"Map creation"
			(=> operator)

			"Return type"
			(-> operator)
			
			"List comprehension"
			(|| operator)
			(<- operator)

			('\s+' space)
		)
	).
]

{ #category : #'as yet unclassified' }
PhanideStyler class >> forExtension: anExtension [
	^ self stylerExtensionDictionary at: anExtension ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
PhanideStyler class >> forFileReference: aFileReference [
	^ self forExtension: aFileReference extension
]

{ #category : #initialization }
PhanideStyler class >> initialize [
	(Pragma allNamed: #styler in: self class) do: [ :pragma |
		self perform: pragma method selector
	]
]

{ #category : #stylers }
PhanideStyler class >> json [
	<styler>
	^ self styler: 'JSON' extensions: #(json) commandHighlighter: PhanideJSONSyntaxHighlighter
]

{ #category : #compiling }
PhanideStyler class >> noteCompilationOf: aSelector meta: isMeta [
	isMeta ifTrue: [
		self class methodDict at: aSelector ifPresent: [:cm |
			(cm hasPragmaNamed: #styler) ifTrue: [
				self perform: aSelector
			]
		]
	]
]

{ #category : #stylers }
PhanideStyler class >> python [
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
]

{ #category : #'as yet unclassified' }
PhanideStyler class >> registerStyler: aStyler [
	self stylerDictionary at: aStyler name put: aStyler.
	aStyler extensions do: [ :ext |
		self stylerExtensionDictionary at: ext put: aStyler
	]
]

{ #category : #'as yet unclassified' }
PhanideStyler class >> styler: stylerName extensions: extensions commandHighlighter: commandHighlighter [
	self registerStyler: (PhanideCommandHighlighterStyler new
		name: stylerName;
		extensions: extensions;
		highlighter: commandHighlighter
		yourself)
]

{ #category : #'as yet unclassified' }
PhanideStyler class >> styler: stylerName extensions: extensions regex: regexDefinition [
	self registerStyler: (PhanideRegexStyler new
		name: stylerName;
		extensions: extensions;
		lexer: (PhanideRegexLexerStyler parse: regexDefinition);
		yourself)
]

{ #category : #'as yet unclassified' }
PhanideStyler class >> stylerDictionary [
	^ StylerDictionary ifNil: [ StylerDictionary := Dictionary new ]
]

{ #category : #'as yet unclassified' }
PhanideStyler class >> stylerExtensionDictionary [
	^ StylerExtensionDictionary ifNil: [ StylerExtensionDictionary := Dictionary new ]
]

{ #category : #accessing }
PhanideStyler >> extensions [
	^ extensions
]

{ #category : #accessing }
PhanideStyler >> extensions: anObject [
	extensions := anObject
]

{ #category : #accessing }
PhanideStyler >> name [
	^ name
]

{ #category : #accessing }
PhanideStyler >> name: anObject [
	name := anObject
]

{ #category : #'instance creation' }
PhanideStyler >> newStyleDecorator [
	^ PhanideTextStylerDecorator new
			phanideStyler: self;
			yourself
]

{ #category : #'as yet unclassified' }
PhanideStyler >> rubricEditingModeForFileReference: aFileReference browserComponent: browserComponent [
	^ PhanideHighlighterTextRubEditingMode new
		browserComponent: browserComponent;
		stylerDecorator: (
			PhanideTextStylerDecorator new
				phanideStyler: self;
				fileReference: aFileReference;
				yourself
		);
		yourself
]

{ #category : #'as yet unclassified' }
PhanideStyler >> styleText: aText [
	^ self styleText: aText fromFileReference: nil
]

{ #category : #'as yet unclassified' }
PhanideStyler >> styleText: aText fromFileReference: aFileReference [
	^ self styleText: aText fromFileReference: aFileReference withStyleTable: PhanideSyntaxStyleTable current
]

{ #category : #'as yet unclassified' }
PhanideStyler >> styleText: aText fromFileReference: aFileReference withStyleTable: styleTable [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PhanideStyler >> textDecoratorInPresentation: rubPresentation fileReference: aFileReference [
	^ PhanideTextStylerDecorator new
			phanideStyler: self;
			fileReference: aFileReference;
			yourself
]
