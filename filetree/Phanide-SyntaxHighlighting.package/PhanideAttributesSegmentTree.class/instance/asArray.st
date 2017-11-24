converting
asArray
	| result destIndex |
	result := Array new: root size.
	destIndex := 1.
	self leavesDo: [ :leaf |
		1 to: leaf size do: [ :i |
			result at: destIndex put: leaf value.
			destIndex := destIndex + 1
		]
	].
	^ result