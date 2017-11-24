initialization
initializeFrom: start to: stop value: initialValue
	root := PhanideAttributesSegmentTreeNode new
		start: start;
		stop: stop;
		value: initialValue