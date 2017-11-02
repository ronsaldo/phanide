as yet unclassified
populateComponent: aComponentClass
	| componentModel |

	"Create the component model"
	componentModel := aComponentClass for: self.
	self installComponentModel: componentModel
