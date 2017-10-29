initialization
initialize
	phanide_context_t := LibPhanideContext.
	phanide_process_t := LibPhanideProcess.
	phanide_event_process_pipe_t := LibPhanideEventProcessPipe.
	phanide_event_process_finished_t := LibPhanideEventProcessFinished.
	phanide_event_t := LibPhanideEvent.
		
	PHANIDE_EVENT_TYPE_NONE := 0.
	PHANIDE_EVENT_TYPE_PROCESS_FINISHED := 1.
	PHANIDE_EVENT_TYPE_PROCESS_PIPE_READY := 2.
	
	PHANIDE_PIPE_INDEX_STDIN := 0.
	PHANIDE_PIPE_INDEX_STDOUT := 1.
	PHANIDE_PIPE_INDEX_STDERR := 2.

	PHANIDE_PIPE_ERROR := -1.
	PHANIDE_PIPE_ERROR_WOULD_BLOCK := -2.
	PHANIDE_PIPE_ERROR_CLOSED := -3.
