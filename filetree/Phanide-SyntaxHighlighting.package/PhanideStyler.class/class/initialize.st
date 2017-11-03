initialization
initialize
	(Pragma allNamed: #styler in: self class) do: [ :pragma |
		self perform: pragma method selector
	]