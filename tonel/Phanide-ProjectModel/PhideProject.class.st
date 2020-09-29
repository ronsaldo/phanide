Class {
	#name : #PhideProject,
	#superclass : #PhideProjectElement,
	#instVars : [
		'topLevelElements',
		'buildPlatforms',
		'activeBuildPlatform',
		'activeBuildMode',
		'activeLaunchProgram',
		'activeBuildSession',
		'activeLaunchSession',
		'activeDebugSession',
		'fileReferenceToElementMap'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #construction }
PhideProject class >> forDirectory: aDirectoryNameOrFileReference [
	^ self new
		addTopLevelElement: aDirectoryNameOrFileReference asFileReference asAbsolute canonicalize asPhanideProjectElement;
		yourself
]

{ #category : #commands }
PhideProject >> actionBuildAll [
	self activeBuildMode ifNotNil: [:buildMode |
		self startNewBuildSession: buildMode newBuildAllSession
	]
]

{ #category : #commands }
PhideProject >> actionCleanAll [
	self activeBuildMode ifNotNil: [:buildMode |
		self startNewBuildSession: buildMode newCleanAllSession
	]
]

{ #category : #commands }
PhideProject >> actionConfigureBuild [
	self activeBuildMode ifNotNil: [:buildMode |
		self startNewBuildSession: buildMode newConfigureSession
	]
]

{ #category : #commands }
PhideProject >> actionDebugContinue [
	self activeDebugSession ifNotNil: [ :s |
		s debugContinue
	]
]

{ #category : #commands }
PhideProject >> actionDebugPause [
	self activeDebugSession ifNotNil: [ :s |
		s debugPause
	]
]

{ #category : #commands }
PhideProject >> actionDebugRun [
	self activeLaunchProgram ifNil: [ ^ self ].
	self startNewDebugSession: self activeLaunchProgram newDebugSession
]

{ #category : #commands }
PhideProject >> actionDebugStepInto [
	self activeDebugSession ifNotNil: [ :s |
		s debugStepInto
	]
]

{ #category : #commands }
PhideProject >> actionDebugStepOver [
	self activeDebugSession ifNotNil: [ :s |
		s debugStepOver
	]
]

{ #category : #commands }
PhideProject >> actionDebugStop [
	self activeDebugSession ifNotNil: [ :s |
		s debugStop
	]
]

{ #category : #commands }
PhideProject >> actionInstallBuild [
	self activeBuildMode ifNotNil: [:buildMode |
		self startNewBuildSession: buildMode newInstallAllSession
	]
]

{ #category : #commands }
PhideProject >> actionRebuildAll [
	self activeBuildMode ifNotNil: [:buildMode |
		self startNewBuildSession: buildMode newRebuildAllSession
	]
]

{ #category : #commands }
PhideProject >> actionRunWithoutDebugging [
	self activeLaunchProgram ifNil: [ ^ self ].
	self startNewLaunchSession: self activeLaunchProgram newLaunchSession
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
PhideProject >> activeBuildSession [
	^ activeBuildSession value
]

{ #category : #accessing }
PhideProject >> activeBuildSession: anObject [
	activeBuildSession value: anObject
]

{ #category : #accessing }
PhideProject >> activeDebugSession [
	^ activeDebugSession value
]

{ #category : #accessing }
PhideProject >> activeDebugSession: anObject [
	activeDebugSession value: anObject
]

{ #category : #accessing }
PhideProject >> activeLaunchProgram [
	^ activeLaunchProgram value
]

{ #category : #accessing }
PhideProject >> activeLaunchProgram: anObject [
	activeLaunchProgram value: anObject
]

{ #category : #accessing }
PhideProject >> activeLaunchSession [
	^ activeLaunchSession value
]

{ #category : #accessing }
PhideProject >> activeLaunchSession: anObject [
	activeLaunchSession value: anObject
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

{ #category : #'as yet unclassified' }
PhideProject >> findOrCreateProjectElementForExistentFile: fileName [
	| fileReference |
	fileReference := fileName asFileReference asAbsolute canonicalize.
	fileReference exists ifFalse: [ ^ nil ].
	fileReference isFile ifFalse: [ ^ nil ].
	^ fileReferenceToElementMap
		at: fileReference
		ifAbsent: [ PhideProjectFileReference for: fileReference ]
]

{ #category : #initialization }
PhideProject >> getProgramLaunchSettingsFor: programName ifAbsentCreateWith: aBlock [
	^ self validActiveBuildMode getProgramLaunchSettingsFor: programName ifAbsentCreateWith: aBlock
]

{ #category : #initialization }
PhideProject >> initialize [
	super initialize.
	fileReferenceToElementMap := Dictionary new.
	topLevelElements := OrderedCollection new asValueHolder.
	buildPlatforms := Dictionary new asValueHolder.
	activeBuildMode := nil asValueHolder.
	activeBuildPlatform := nil asValueHolder.
	activeLaunchProgram := nil asValueHolder.
	activeBuildSession := nil asValueHolder.
	activeLaunchSession := nil asValueHolder.
	activeDebugSession := nil asValueHolder
]

{ #category : #testing }
PhideProject >> isEmpty [
	^ topLevelElements isEmpty
]

{ #category : #'as yet unclassified' }
PhideProject >> mapFileReference: fileReference toElement: anElement [
	fileReferenceToElementMap at: fileReference asAbsolute canonicalize put: anElement
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

{ #category : #'as yet unclassified' }
PhideProject >> projectRootDirectoryElement [
	^ topLevelElements first
]

{ #category : #'as yet unclassified' }
PhideProject >> resolveProjectRelativePath: path [
	| rootFileReference |
	rootFileReference := self projectRootDirectoryElement fileReference.
	path isEmpty ifTrue: [ ^ rootFileReference asAbsolute canonicalize fullName ].
	^ (rootFileReference resolve: path asFileReference) asAbsolute canonicalize fullName
]

{ #category : #commands }
PhideProject >> startNewBuildSession: newBuildSession [
	newBuildSession ifNil: [ ^ newBuildSession ].
	
	self terminateCurrentBuildSession.
	self activeBuildSession: newBuildSession.
	newBuildSession start
]

{ #category : #commands }
PhideProject >> startNewDebugSession: newDebugSession [
	newDebugSession ifNil: [ ^ self ].
	
	self terminateCurrentLaunchSession.
	self terminateCurrentDebugSession.
	self activeDebugSession: newDebugSession.
	newDebugSession start
]

{ #category : #commands }
PhideProject >> startNewLaunchSession: newLaunchSession [
	newLaunchSession ifNil: [ ^ self ].
	
	self terminateCurrentLaunchSession.
	self terminateCurrentDebugSession.
	self activeLaunchSession: newLaunchSession.
	newLaunchSession start
]

{ #category : #commands }
PhideProject >> terminateCurrentBuildSession [
	self activeBuildSession ifNotNil: [ :oldSession |
		oldSession terminate.
		self activeBuildSession: nil
	].
]

{ #category : #commands }
PhideProject >> terminateCurrentDebugSession [
	self activeDebugSession ifNotNil: [ :oldSession |
		oldSession terminate.
		self activeDebugSession: nil
	].
]

{ #category : #commands }
PhideProject >> terminateCurrentLaunchSession [
	self activeLaunchSession ifNotNil: [ :oldSession |
		oldSession terminate.
		self activeLaunchSession: nil
	].
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
PhideProject >> whenActiveBuildSessionChangedDo: aBlock [
	activeBuildSession whenChangedDo: aBlock
]

{ #category : #enumerating }
PhideProject >> whenActiveDebugSessionChangedDo: aBlock [
	activeDebugSession whenChangedDo: aBlock
]

{ #category : #enumerating }
PhideProject >> whenActiveLaunchProgramChangedDo: aBlock [
	activeLaunchProgram whenChangedDo: aBlock
]

{ #category : #enumerating }
PhideProject >> whenActiveLaunchSessionChangedDo: aBlock [
	activeLaunchSession whenChangedDo: aBlock
]

{ #category : #initialization }
PhideProject >> whenBuildPlatformsChangedDo: aBlock [
	buildPlatforms whenChangedDo: aBlock
]

{ #category : #enumerating }
PhideProject >> whenTopLevelElementsChangedDo: aBlock [
	topLevelElements whenChangedDo: aBlock
]
