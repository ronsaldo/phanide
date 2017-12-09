file system
onFSMonitorEvent: event
	| namePointer name handle eventHandle |
	namePointer := event name.
	name := nil.
	(namePointer isNotNil and: [ namePointer isNull not ]) ifTrue: [ 
		name := namePointer readStringUTF8.
		LibPhanide uniqueInstance free: namePointer
	].

	eventHandle := event handle.
	fsmonitorMutex critical: [
		handle := fsmonitorDictionary at: eventHandle getHandle ifAbsent: [ nil ].
		(event mask anyMask: PHANIDE_FSMONITOR_EVENT_DELETE_SELF) ifTrue: [ 
			(LibPhanideFSMonitor fromHandle: eventHandle) destroyOnContext: context.
			fsmonitorDictionary removeKey: eventHandle getHandle ifAbsent: []
		]
	].

	handle ifNotNil: [
		handle eventHandler ifNotNil: [ :handler |
			handler value: (PhanideFSMonitorWatchEvent new
				handle: handle;
				mask: event mask;
				cookie: event cookie;
				name: name;
				yourself)
		].
	].
