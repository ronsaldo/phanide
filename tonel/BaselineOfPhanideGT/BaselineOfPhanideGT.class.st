Class {
	#name : #BaselineOfPhanideGT,
	#superclass : #BaselineOf,
	#category : #BaselineOfPhanideGT
}

{ #category : #baselines }
BaselineOfPhanideGT >> baseline: spec [
	<baseline>
	| repository |
	repository := self packageRepositoryURL ifEmpty: ['gitlocal://tonel'].
	
	spec for: #common do: [
		spec baseline: #'PhanideCore' with: [ spec repository: repository ].
		spec
			package: #'Phanide-SyntaxHighlightingGToolkit' with: [
				spec requires: #('PhanideCore')
			].
	].
]
