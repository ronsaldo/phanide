Class {
	#name : #PhideProjectBuildMode,
	#superclass : #Object,
	#instVars : [
		'name',
		'buildMethod',
		'launchSettings',
		'platform'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #'instance creation' }
PhideProjectBuildMode class >> newDefault [
	^ self new name: 'Default'; yourself
]

{ #category : #accessing }
PhideProjectBuildMode >> buildMethod [
	^ buildMethod
]

{ #category : #accessing }
PhideProjectBuildMode >> buildMethod: anObject [
	buildMethod := anObject
]

{ #category : #initialization }
PhideProjectBuildMode >> getProgramLaunchSettingsFor: programName ifAbsentCreateWith: aBlock [
	^ launchSettings at: programName ifAbsentPut: [
			| settings |
			settings := aBlock value.
			settings buildMode: self; program: programName.
			settings
		]
]

{ #category : #initialization }
PhideProjectBuildMode >> initialize [
	super initialize.
	launchSettings := Dictionary new asValueHolder.
]

{ #category : #accessing }
PhideProjectBuildMode >> launchSettings [
	^ launchSettings
]

{ #category : #accessing }
PhideProjectBuildMode >> name [
	^ name
]

{ #category : #accessing }
PhideProjectBuildMode >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PhideProjectBuildMode >> platform [
	^ platform
]

{ #category : #accessing }
PhideProjectBuildMode >> platform: anObject [
	platform := anObject
]
