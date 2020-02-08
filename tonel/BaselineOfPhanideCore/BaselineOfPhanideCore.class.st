Class {
	#name : #BaselineOfPhanideCore,
	#superclass : #BaselineOf,
	#category : #BaselineOfPhanideCore
}

{ #category : #baselines }
BaselineOfPhanideCore >> baseline: spec [
	<baseline>

	| conditionalDeps |
	spec for: #common do: [
		conditionalDeps := #().
		Smalltalk globals at: #PP2CompositeNode ifAbsent: [ 
			conditionalDeps := { #'PetitParser2Core' }.
			spec baseline: #'PetitParser2Core' with: [
					spec
						repository: 'github://kursjan/petitparser2' ].
		].
				
		spec
			package: #'Phanide-SyntaxHighlighting' with: [
				spec requires: conditionalDeps
			].
		spec
			package: #'Phanide-GDB' with: [
				spec requires: #(#'OSIOEvents')
			].
	].
]
