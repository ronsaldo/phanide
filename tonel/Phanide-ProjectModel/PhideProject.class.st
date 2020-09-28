Class {
	#name : #PhideProject,
	#superclass : #PhideProjectElement,
	#instVars : [
		'topLevelElements',
		'buildPlatforms',
		'activeBuildPlatform',
		'activeBuildMode',
		'activeLaunchProgram'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #construction }
PhideProject class >> forDirectory: aDirectoryNameOrFileReference [
	^ self new
		addTopLevelElement: aDirectoryNameOrFileReference asFileReference asAbsolute canonicalize asPhanideProjectElement;
		yourself
]

{ #category : #'as yet unclassified' }
PhideProject >> activateLaunchProgramNamed: launchProgramName [
	self halt
]

{ #category : #accessing }
PhideProject >> activeBuildMode [
	^ activeBuildMode value
]

{ #category : #accessing }
PhideProject >> activeBuildMode: anObject [
	activeBuildMode value: anObject
]

{ #category : #accessing }
PhideProject >> activeBuildPlatform [
	^ activeBuildPlatform value
]

{ #category : #accessing }
PhideProject >> activeBuildPlatform: anObject [
	activeBuildPlatform value: anObject
]

{ #category : #accessing }
PhideProject >> activeLaunchProgram [
	^ activeLaunchProgram value
]

{ #category : #accessing }
PhideProject >> activeLaunchProgram: anObject [
	activeLaunchProgram value: anObject
]

{ #category : #adding }
PhideProject >> addBuildPlatform: buildPlatform [
	self assert: buildPlatform project isNil.
	buildPlatforms at: buildPlatform name put: buildPlatform.
	buildPlatform project: self
]

{ #category : #adding }
PhideProject >> addTopLevelElement: anElement [
	anElement parent: self.
	topLevelElements add: anElement
]

{ #category : #accessing }
PhideProject >> buildPlatforms [
	^ buildPlatforms value
]

{ #category : #accessing }
PhideProject >> children [
	^ topLevelElements value
]

{ #category : #initialization }
PhideProject >> defaultValidBuildPlatform [
	buildPlatforms ifEmpty: [
		self addBuildPlatform: PhideProjectBuildPlatform newDefault.
	].
	
	^ self activeBuildPlatform: buildPlatforms anyOne
]

{ #category : #initialization }
PhideProject >> getProgramLaunchSettingsFor: programName ifAbsentCreateWith: aBlock [
	^ self validActiveBuildMode getProgramLaunchSettingsFor: programName ifAbsentCreateWith: aBlock
]

{ #category : #initialization }
PhideProject >> initialize [
	super initialize.
	topLevelElements := OrderedCollection new asValueHolder.
	buildPlatforms := Dictionary new asValueHolder.
	activeBuildMode := nil asValueHolder.
	activeBuildPlatform := nil asValueHolder.
	activeLaunchProgram := nil asValueHolder.
]

{ #category : #testing }
PhideProject >> isEmpty [
	^ topLevelElements isEmpty
]

{ #category : #accessing }
PhideProject >> name [
	^ 'Project'
]

{ #category : #operations }
PhideProject >> openBrowser [
	^ (PhideProjectBrowser on: self) openWithSpec
]

{ #category : #accessing }
PhideProject >> project [
	^ self
]

{ #category : #initialization }
PhideProject >> topLevelElements [
	^ topLevelElements value asArray
]

{ #category : #initialization }
PhideProject >> validActiveBuildMode [
	self activeBuildMode ifNil: [
		self activeBuildMode: self validActiveBuildPlatform defaultValidBuildMode
	].
	^ self activeBuildMode
]

{ #category : #initialization }
PhideProject >> validActiveBuildPlatform [
	self activeBuildPlatform ifNil: [
		self defaultValidBuildPlatform
	].
	^ self activeBuildPlatform
]

{ #category : #enumerating }
PhideProject >> whenActiveBuildModeChangedDo: aBlock [
	activeBuildMode whenChangedDo: aBlock
]

{ #category : #enumerating }
PhideProject >> whenActiveBuildPlatformChangedDo: aBlock [
	activeBuildPlatform whenChangedDo: aBlock
]

{ #category : #enumerating }
PhideProject >> whenActiveLaunchProgramChangedDo: aBlock [
	activeLaunchProgram whenChangedDo: aBlock
]

{ #category : #initialization }
PhideProject >> whenBuildPlatformsChangedDo: aBlock [
	buildPlatforms whenChangedDo: aBlock
]

{ #category : #enumerating }
PhideProject >> whenTopLevelElementsChangedDo: aBlock [
	topLevelElements whenChangedDo: aBlock
]
