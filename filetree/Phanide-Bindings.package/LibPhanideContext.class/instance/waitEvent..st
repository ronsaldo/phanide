events
waitEvent: anEvent
	^ self ffiCall: #(bool phanide_waitEvent(self, phanide_event_t *anEvent))