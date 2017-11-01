private
newFutureCommandResult
	| token result |
	token := self newToken.
	result := PhanideGDBFutureCommandResult new token: token.
	pendingCommandsMutex critical: [ 
		pendingCommands at: token put: result
	].
	^ result