gt-extension
gtInspectorDescriptionIn: composite
	"This is the most basic presentation showing the state of the object"
	<gtInspectorPresentationOrder: 5>
	^ composite text
		title: 'State Machine';
		display: [ self ]