field definition
fieldsDesc
	"
	self rebuildFieldAccessors
	"
	^ #(
		uint32 type;
		phanide_event_process_pipe_t processPipe;
		phanide_event_process_finished_t processFinished;
		padding16 padding;
	)