private
newToken
	| result |
	tokenCountMutex critical: [ 
		result := (tokenCount := tokenCount + 1).
	].
	^ result
	