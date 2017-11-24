as yet unclassified
executeOnSegmentTree: tree withStyleTable: styleTable
	| attributes |
	attributes := styleTable textAttributesForStyle: style.
	tree from: start to: stop put: attributes