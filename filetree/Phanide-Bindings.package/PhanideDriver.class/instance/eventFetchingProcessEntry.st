events
eventFetchingProcessEntry
	[
		[
			(session ~~ Smalltalk session or: [context isNil or: [context isNull]]) ifTrue: [ ^ self ].
			pendingEventsSemaphore consumeAllSignals.
			
			self eventFetchingIteration.
			
			pendingEventsSemaphore wait
		] repeat
	] ensure: [ Smalltalk unregisterExternalObject: pendingEventsSemaphore ]