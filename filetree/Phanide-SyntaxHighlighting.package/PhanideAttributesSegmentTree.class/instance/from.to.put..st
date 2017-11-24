instance creation
from: start to: stop put: newValue
	self assert: newValue isNotNil.
	root from: start to: stop put: newValue