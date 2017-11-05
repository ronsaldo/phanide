accessing
alternations
	^ super alternations ==> [ :list |
		| result |
		result := list first.
		list second do: [ :alternative | result := result / alternative second ].
		result
	]