accessing
sequence
	^ super sequence ==> [ :list |
		| result |
		result := PhanideNFA epsilon.
		list do: [ :el | result := result , el ].
		result
	]