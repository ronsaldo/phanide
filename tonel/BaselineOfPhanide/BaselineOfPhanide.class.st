Class {
	#name : #BaselineOfPhanide,
	#superclass : #BaselineOf,
	#category : #BaselineOfPhanide
}

{ #category : #baselines }
BaselineOfPhanide >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec project: 'PetitParser' with: [
				spec
					className: #ConfigurationOfPetitParser;
					versionString: #'development';
					loads: #('Core' );
					repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/'
		].
		spec
			package: 'Phanide-Bindings' with: [
				spec requires: #('PetitParser')
			].
		spec
			package: 'Phanide-SyntaxHighlighting' with: [
				spec requires: #('PetitParser')
			].
		spec
			package: 'Phanide-Browser' with: [
				spec requires: #('Phanide-Bindings' 'Phanide-SyntaxHighlighting')
			].
		spec
			package: 'Phanide-GDB' with: [
				spec requires: #('Phanide-Bindings')
			].
	].
]
