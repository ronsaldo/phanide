accessing
next: n
	| result c |
	result := ByteString new: n.
	1 to: n do: [ :i |
		c := self next.
		c ifNil: [
			^ result copyFrom: 1 to: i - 1
		].
		result at: i put: c
	].

	^ result