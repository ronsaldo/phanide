Class {
	#name : #PhideProjectMakefileBuildSettings,
	#superclass : #PhideProjectBuildMethod,
	#instVars : [
		'buildDirectory',
		'configureCommand',
		'makefile',
		'buildCommand',
		'cleanCommand',
		'rebuildCommand',
		'installCommand'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #templates }
PhideProjectMakefileBuildSettings class >> forCMakeInBuildDir: buildDirectory [
	^ self new
		buildDirectory: buildDirectory;
		configureCommand: ('cmake {1} -G "Unix Makefiles"' format: {('.' asFileReference relativeTo: buildDirectory asFileReference) fullName});
		makefile: (buildDirectory asFileReference / 'Makefile') fullName;
		buildCommand: 'make';
		installCommand: 'make install';
		cleanCommand: 'make clean';
		rebuildCommand: 'make clean all';
		yourself
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> buildCommand [
	^ buildCommand
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> buildCommand: anObject [
	buildCommand := anObject
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> buildDirectory [
	^ buildDirectory
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> buildDirectory: anObject [
	buildDirectory := anObject
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> cleanCommand [
	^ cleanCommand
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> cleanCommand: anObject [
	cleanCommand := anObject
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> configureCommand [
	^ configureCommand
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> configureCommand: anObject [
	configureCommand := anObject
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> installCommand [
	^ installCommand
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> installCommand: anObject [
	installCommand := anObject
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> makefile [
	^ makefile
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> makefile: anObject [
	makefile := anObject
]

{ #category : #'as yet unclassified' }
PhideProjectMakefileBuildSettings >> newBuildAllSession [
	(buildCommand isNil or: [buildCommand isEmpty]) ifTrue: [ ^ nil ].
	^ PhideProgramBuildSession new
		shellCommand: buildCommand inWorkingDirectory: (self resolveProjectRelativePath: buildDirectory);
		yourself
]

{ #category : #'as yet unclassified' }
PhideProjectMakefileBuildSettings >> newCleanAllSession [
	(cleanCommand isNil or: [cleanCommand isEmpty]) ifTrue: [ ^ nil ].
	^ PhideProgramBuildSession new
		shellCommand: cleanCommand inWorkingDirectory: (self resolveProjectRelativePath: buildDirectory);
		yourself
]

{ #category : #'as yet unclassified' }
PhideProjectMakefileBuildSettings >> newConfigureSession [
	(configureCommand isNil or: [configureCommand isEmpty]) ifTrue: [ ^ nil ].
	^ PhideProgramBuildSession new
		shellCommand: configureCommand inWorkingDirectory: (self resolveProjectRelativePath: buildDirectory);
		yourself
]

{ #category : #'as yet unclassified' }
PhideProjectMakefileBuildSettings >> newInstallAllSession [
	(installCommand isNil or: [installCommand isEmpty]) ifTrue: [ ^ nil ].
	^ PhideProgramBuildSession new
		shellCommand: installCommand inWorkingDirectory: (self resolveProjectRelativePath: buildDirectory);
		yourself
]

{ #category : #'as yet unclassified' }
PhideProjectMakefileBuildSettings >> newRebuildAllSession [
	(rebuildCommand isNil or: [rebuildCommand isEmpty]) ifTrue: [ ^ nil ].
	^ PhideProgramBuildSession new
		shellCommand: rebuildCommand inWorkingDirectory: (self resolveProjectRelativePath: buildDirectory);
		yourself
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> rebuildCommand [
	^ rebuildCommand
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> rebuildCommand: anObject [
	rebuildCommand := anObject
]
