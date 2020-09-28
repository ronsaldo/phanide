Class {
	#name : #PhideProgramLaunchSettings,
	#superclass : #Object,
	#instVars : [
		'buildMode',
		'name',
		'program',
		'workingDirectory',
		'commandLineArguments',
		'environmentVariables'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #accessing }
PhideProgramLaunchSettings >> buildMode [
	^ buildMode
]

{ #category : #accessing }
PhideProgramLaunchSettings >> buildMode: anObject [
	buildMode := anObject
]

{ #category : #accessing }
PhideProgramLaunchSettings >> commandLineArguments [
	^ commandLineArguments
]

{ #category : #accessing }
PhideProgramLaunchSettings >> commandLineArguments: anObject [
	commandLineArguments := anObject
]

{ #category : #accessing }
PhideProgramLaunchSettings >> environmentVariables [
	^ environmentVariables
]

{ #category : #accessing }
PhideProgramLaunchSettings >> environmentVariables: anObject [
	environmentVariables := anObject
]

{ #category : #initialization }
PhideProgramLaunchSettings >> initialize [
	super initialize.
	commandLineArguments := ''.
	
]

{ #category : #accessing }
PhideProgramLaunchSettings >> name [
	^ name
]

{ #category : #accessing }
PhideProgramLaunchSettings >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PhideProgramLaunchSettings >> program [
	^ program
]

{ #category : #accessing }
PhideProgramLaunchSettings >> program: anObject [
	program := anObject
]

{ #category : #accessing }
PhideProgramLaunchSettings >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
PhideProgramLaunchSettings >> workingDirectory: anObject [
	workingDirectory := anObject
]
