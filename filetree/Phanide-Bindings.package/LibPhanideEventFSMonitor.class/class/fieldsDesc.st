field definition
fieldsDesc
	"
	self rebuildFieldAccessors
	"
	^ #(
		uint32 type;
		phanide_fsmonitor_handle_t handle;
    	uint32 mask;
    	uint32 cookie;
    	uint32 nameLength;
    	char* name;
	)