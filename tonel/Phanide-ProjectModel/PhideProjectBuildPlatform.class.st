Class {
	#name : #PhideProjectBuildPlatform,
	#superclass : #Object,
	#instVars : [
		'project',
		'name',
		'buildModes'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #'instance creation' }
PhideProjectBuildPlatform class >> newDefault [
	^ self new name: 'Default'; yourself
]

{ #category : #'as yet unclassified' }
PhideProjectBuildPlatform >> addBuildMode: buildMode [
	self assert: buildMode platform isNil.
	buildModes at: buildMode name put: buildMode.
	buildMode platform: self
]

{ #category : #accessing }
PhideProjectBuildPlatform >> buildModes [
	^ buildModes value
]

{ #category : #'as yet unclassified' }
PhideProjectBuildPlatform >> defaultValidBuildMode [
	buildModes ifEmpty: [
		self addBuildMode: PhideProjectBuildMode newDefault
	].

	^ buildModes anyOne
]

{ #category : #initialization }
PhideProjectBuildPlatform >> initialize [
	super initialize.
	buildModes := OrderedDictionary new asValueHolder.
]

{ #category : #accessing }
PhideProjectBuildPlatform >> name [
	^ name
]

{ #category : #accessing }
PhideProjectBuildPlatform >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PhideProjectBuildPlatform >> project [
	^ project
]

{ #category : #accessing }
PhideProjectBuildPlatform >> project: anObject [
	project := anObject
]
