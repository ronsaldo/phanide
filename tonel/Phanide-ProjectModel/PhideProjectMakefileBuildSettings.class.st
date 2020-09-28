Class {
	#name : #PhideProjectMakefileBuildSettings,
	#superclass : #PhideProjectBuildMethod,
	#instVars : [
		'buildDirectory',
		'configureCommand',
		'makefile',
		'buildCommand',
		'cleanCommand'
	],
	#category : #'Phanide-ProjectModel'
}

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
PhideProjectMakefileBuildSettings >> makefile [
	^ makefile
]

{ #category : #accessing }
PhideProjectMakefileBuildSettings >> makefile: anObject [
	makefile := anObject
]
