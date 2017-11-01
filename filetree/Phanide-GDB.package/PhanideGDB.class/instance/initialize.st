initialization
initialize
	super initialize.
	eventHandler := PhanideGDBTranscriptOutputEventHandler new.
	
	tokenCountMutex := Semaphore forMutualExclusion.
	tokenCount := 0.
	