Class {
	#name : #PhideProjectFileReference,
	#superclass : #PhideProjectFileSystemElement,
	#category : #'Phanide-ProjectModel'
}

{ #category : #converting }
PhideProjectFileReference >> asValidLaunchProgramSettings [
	| projectRelativeFileReference projectRelativePath |
	projectRelativeFileReference := self projectRootRelativeFileReference.
	projectRelativePath := projectRelativeFileReference fullName.
	
	^ self project getProgramLaunchSettingsFor: projectRelativePath ifAbsentCreateWith: [
		PhideProgramLaunchSettings new
			name: projectRelativeFileReference basename;
			workingDirectory: projectRelativeFileReference parent fullName;
			yourself
	]
]

{ #category : #accessing }
PhideProjectFileReference >> iconName [
	^ #glamorousBrowse
]
