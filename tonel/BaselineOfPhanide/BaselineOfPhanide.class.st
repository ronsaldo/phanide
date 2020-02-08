Class {
	#name : #BaselineOfPhanide,
	#superclass : #BaselineOf,
	#category : #BaselineOfPhanide
}

{ #category : #baselines }
BaselineOfPhanide >> baseline: spec [
	<baseline>
	| repository |
	repository := self packageRepositoryURL ifEmpty: ['github://ronsaldo/phanide/tonel'].

	spec for: #common do: [
		spec baseline: #'PhanideCore' with: [ spec repository: repository ].
		spec baseline: #'GDBBindings' with: [
			spec repository: 'github://ronsaldo/gdb-bindings'
		].
		spec
			package: #'Phanide-Browser' with: [
				spec requires: #(#'PhanideCore')
			].
		spec
			package: #'Phanide-BrowserGDB' with: [
				spec requires: #(#'PhanideCore' #'GDBBindings' #'Phanide-Browser')
			].
	].
]
