as yet unclassified
styler: stylerName extensions: extensions commandHighlighter: commandHighlighter
	self registerStyler: (PhanideCommandHighlighterStyler new
		name: stylerName;
		extensions: extensions;
		highlighter: commandHighlighter
		yourself)