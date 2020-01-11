Class {
	#name : #BaselineOfPhanideGT,
	#superclass : #BaselineOf,
	#category : #BaselineOfPhanideGT
}

{ #category : #baselines }
BaselineOfPhanideGT >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec baseline: #'PhanideCore' with: [
				spec
					repository: 'github://ronsaldo/phanide/tonel' ].
		spec
			package: 'Phanide-SyntaxHighlightingGToolkit' with: [
				spec requires: #('PhanideCore')
			].
	].
]
