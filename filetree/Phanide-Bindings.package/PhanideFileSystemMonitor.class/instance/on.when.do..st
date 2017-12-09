event subscriptions
on: aPath when: anEvent do: aBlock
	| watchedFileReference watchedElement |
	PhanideDriver isAvailable ifFalse: [ ^ self ].
	
	self checkSession.
	watchedFileReference := aPath asFileReference asAbsolute.
	watchedFileReference exists ifFalse: [ ^ self ].
	
	registeredFilesMutex critical: [
		watchedElement := registeredFiles at: watchedFileReference
			ifAbsentPut: [ PhanideFileSystemMonitorWatchedElement for: watchedFileReference ]
	].

	watchedElement announcer when: anEvent do: aBlock