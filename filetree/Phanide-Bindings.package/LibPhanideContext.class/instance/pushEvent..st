events
pushEvent: anEvent
	^ self ffiCall: #(int phanide_pushEvent(self, phanide_event_t *anEvent))