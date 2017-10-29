events
pollEvent: anEvent
	^ self ffiCall: #(bool phanide_pollEvent(self, phanide_event_t *anEvent))