testing
isAvailable
	| result |
	result := true.
	[
		ExternalAddress loadSymbol: 'phanide_createContext' from: self
	] on: Error do: [ :e | result := false ].
	^ result