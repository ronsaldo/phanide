initialization
initialize
	EventDispatchMap := Dictionary newFromPairs: {
		PHANIDE_EVENT_TYPE_PROCESS_PIPE_READY . #(processPipe onProcessPipeEvent:) .
		PHANIDE_EVENT_TYPE_PROCESS_FINISHED . #(processFinished onProcessFinishedEvent:) .
		PHANIDE_EVENT_TYPE_FSMONITOR . #(fsmonitor onFSMonitorEvent: ).
	}.
