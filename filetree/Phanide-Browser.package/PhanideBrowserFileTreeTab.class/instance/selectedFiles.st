accessing
selectedFiles
	| ds |
	ds := treeMorph dataSource.
	^ treeMorph selectedRowIndexes collect: [ :i |
		(ds elementAt: i) data
	]