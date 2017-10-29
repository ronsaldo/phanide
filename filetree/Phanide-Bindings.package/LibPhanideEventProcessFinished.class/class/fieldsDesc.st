field definition
fieldsDesc
	"
	self rebuildFieldAccessors
	"
	^ #(
		uint32 type;
		phanide_process_t process;
		int32 exitCode;
	)