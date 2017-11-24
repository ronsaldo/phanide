as yet unclassified
gtInspectorTree: composite
	<gtInspectorPresentationOrder: 20>
	composite tree 
		title: 'Tree';
		display: [ :root | self ];
		children: [ :each | each children ]