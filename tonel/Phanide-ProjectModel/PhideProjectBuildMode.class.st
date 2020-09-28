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
	buildMethod := anObject.
	buildMethod buildMode: self.
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

{ #category : #'as yet unclassified' }
PhideProjectBuildMode >> newBuildAllSession [
	^ buildMethod ifNotNil: [ buildMethod newBuildAllSession ]
]

{ #category : #'as yet unclassified' }
PhideProjectBuildMode >> newCleanAllSession [
	^ buildMethod ifNotNil: [ buildMethod newCleanAllSession ]
]

{ #category : #'as yet unclassified' }
PhideProjectBuildMode >> newConfigureSession [
	^ buildMethod ifNotNil: [ buildMethod newConfigureSession ]
]

{ #category : #'as yet unclassified' }
PhideProjectBuildMode >> newInstallAllSession [
	^ buildMethod ifNotNil: [ buildMethod newInstallAllSession ]
]

{ #category : #'as yet unclassified' }
PhideProjectBuildMode >> newRebuildAllSession [
	^ buildMethod ifNotNil: [ buildMethod newRebuildAllSession ]
]

{ #category : #accessing }
PhideProjectBuildMode >> platform [
	^ platform
]

{ #category : #accessing }
PhideProjectBuildMode >> platform: anObject [
	platform := anObject
]

{ #category : #accessing }
PhideProjectBuildMode >> project [
	^ platform project
]
