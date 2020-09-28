Class {
	#name : #PhideProjectBuildMethod,
	#superclass : #Object,
	#instVars : [
		'buildMode'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #accessing }
PhideProjectBuildMethod >> buildMode [
	^ buildMode
]

{ #category : #accessing }
PhideProjectBuildMethod >> buildMode: anObject [
	buildMode := anObject
]

{ #category : #'as yet unclassified' }
PhideProjectBuildMethod >> newBuildAllSession [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PhideProjectBuildMethod >> newCleanAllSession [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PhideProjectBuildMethod >> newConfigureSession [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PhideProjectBuildMethod >> newInstallAllSession [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PhideProjectBuildMethod >> newRebuildAllSession [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PhideProjectBuildMethod >> project [
	^ buildMode project
]

{ #category : #'as yet unclassified' }
PhideProjectBuildMethod >> resolveProjectRelativePath: path [
	^ self project resolveProjectRelativePath: path
]
