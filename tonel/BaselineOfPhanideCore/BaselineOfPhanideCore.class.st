Class {
	#name : #BaselineOfPhanideCore,
	#superclass : #BaselineOf,
	#category : #BaselineOfPhanideCore
}

{ #category : #baselines }
BaselineOfPhanideCore >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec
			baseline: #'OSIOEvents' with: [
				spec
					repository: 'github://ronsaldo/os-ioevents' ].

		spec project: 'PetitParser' with: [
				spec
					className: #ConfigurationOfPetitParser;
					versionString: #'development';
					loads: #('Core' );
					repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/'
		].
				
		spec
			package: #'Phanide-SyntaxHighlighting' with: [
				spec requires: #(#'PetitParser')
			].
		spec
			package: #'Phanide-GDB' with: [
				spec requires: #(#'OSIOEvents')
			].
	].
]
