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
		spec baseline: #'Spec2Terminal' with: [
			spec repository: 'github://ronsaldo/spec2-terminal'
		].
		spec
			package: #'Phanide-Browser' with: [
				spec requires: #(#'PhanideCore')
			].
		spec
			package: #'Phanide-BrowserGDB' with: [
				spec requires: #(#'PhanideCore' #'GDBBindings' #'Phanide-Browser')
			].

		spec
			package: #'Phanide-ProjectModel' with: [
				spec requires: #(#'PhanideCore')
			].

		spec
			package: #'Phanide-ProjectModel-Tests' with: [
				spec requires: #(#'Phanide-ProjectModel')
			].
		spec
			package: #'Phanide-ProjectBrowser' with: [
				spec requires: #(#'Phanide-ProjectModel' #'Spec2Terminal')
			].
		spec
			package: #'Phanide-ProjectBrowser-Tests' with: [
				spec requires: #(#'Phanide-ProjectBrowser')
			].
	].
]
