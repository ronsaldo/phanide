events
processEvent: anEvent
	| dispatchMethods |
	dispatchMethods := EventDispatchMap at: anEvent type ifAbsent: [ ^ self ].
	self perform: dispatchMethods second with: (anEvent perform: dispatchMethods first)