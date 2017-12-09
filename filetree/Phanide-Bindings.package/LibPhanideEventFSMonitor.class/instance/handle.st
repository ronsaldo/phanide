accessing structure variables
handle
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_HANDLE) type: ExternalType void asPointerType