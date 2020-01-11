Class {
	#name : #BaselineOfPhanide,
	#superclass : #BaselineOf,
	#category : #BaselineOfPhanide
}

{ #category : #baselines }
BaselineOfPhanide >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec baseline: #'PhanideCore' with: [
				spec
					repository: 'github://ronsaldo/phanide/tonel' ].
		spec
			package: 'Phanide-Browser' with: [
				spec requires: #('Phanide-Bindings' 'Phanide-SyntaxHighlighting')
			].
		spec
			package: 'Phanide-BrowserGDB' with: [
				spec requires: #('Phanide-GDB' 'Phanide-Browser')
			].
	].
]
