Class {
	#name : #BaselineOfPhanideCore,
	#superclass : #BaselineOf,
	#category : #BaselineOfPhanideCore
}

{ #category : #baselines }
BaselineOfPhanideCore >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec postLoadDoIt: #postLoadActions.
		spec
			baseline: #'PhaNAPI' with: [
				spec
					repository: 'github://ronsaldo/phanapi' ].

		spec project: 'PetitParser' with: [
				spec
					className: #ConfigurationOfPetitParser;
					versionString: #'development';
					loads: #('Core' );
					repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/'
		].
				
		spec
			package: #'Phanide-Bindings' with: [
				spec requires: #(#'PhaNAPI' #'PetitParser')
			].
		spec
			package: #'Phanide-SyntaxHighlighting' with: [
				spec requires: #(#'PetitParser')
			].
		spec
			package: #'Phanide-GDB' with: [
				spec requires: #(#'Phanide-Bindings')
			].
	].
]

{ #category : #doits }
BaselineOfPhanideCore >> postLoadActions [
	(Smalltalk globals at: #LibPhanideBindings) fetchLibrary
]
