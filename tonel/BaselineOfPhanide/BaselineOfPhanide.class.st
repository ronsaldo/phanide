Class {
	#name : #BaselineOfPhanide,
	#superclass : #BaselineOf,
	#category : #BaselineOfPhanide
}

{ #category : #baselines }
BaselineOfPhanide >> baseline: spec [
	<baseline>
	| repository |
	repository := self packageRepositoryURL ifEmpty: ['gitlocal://tonel'].

	spec for: #common do: [
		spec baseline: #'PhanideCore' with: [ spec repository: repository ].
		spec
			package: #'Phanide-Browser' with: [
				spec requires: #(#'PhanideCore')
			].
		spec
			package: #'Phanide-BrowserGDB' with: [
				spec requires: #(#'PhanideCore' #'Phanide-Browser')
			].
	].
]
