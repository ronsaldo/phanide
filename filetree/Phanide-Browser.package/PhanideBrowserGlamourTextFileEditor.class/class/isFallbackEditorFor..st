testing
isFallbackEditorFor: aFileReference
	[
		aFileReference contents 
	] on: Error do: [
		^ false
	].
	^ true