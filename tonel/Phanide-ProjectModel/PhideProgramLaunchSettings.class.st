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

{ #category : #'as yet unclassified' }
PhideProgramLaunchSettings >> absoluteProgramName [
	^ self resolveProjectRelativePath: program
]

{ #category : #'as yet unclassified' }
PhideProgramLaunchSettings >> absoluteWorkingDirectory [
	^ self resolveProjectRelativePath: workingDirectory
]

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
	^ commandLineArguments ifNil: [ commandLineArguments := '' ]
]

{ #category : #accessing }
PhideProgramLaunchSettings >> commandLineArguments: anObject [
	commandLineArguments := anObject
]

{ #category : #accessing }
PhideProgramLaunchSettings >> environmentVariables [
	^ environmentVariables ifNil: [ environmentVariables := OrderedDictionary new ]
]

{ #category : #accessing }
PhideProgramLaunchSettings >> environmentVariables: anObject [
	environmentVariables := anObject as: OrderedDictionary
]

{ #category : #'instance creation' }
PhideProgramLaunchSettings >> formatShellCommand [
	^ self absoluteProgramName , ' ' , commandLineArguments
]

{ #category : #accessing }
PhideProgramLaunchSettings >> name [
	^ name
]

{ #category : #accessing }
PhideProgramLaunchSettings >> name: anObject [
	name := anObject
]

{ #category : #'instance creation' }
PhideProgramLaunchSettings >> newDebugSession [
	^ PhideProgramGDBDebugSession new
		programFileName: self absoluteProgramName;
		commandLineArguments: self commandLineArguments;
		workingDirectory: self absoluteWorkingDirectory;
		environmentVariables: self environmentVariables;
		yourself
]

{ #category : #'instance creation' }
PhideProgramLaunchSettings >> newLaunchSession [
	^ PhideProgramLaunchSession new
		shellCommand: self formatShellCommand inWorkingDirectory: self absoluteWorkingDirectory;
		yourself
]

{ #category : #accessing }
PhideProgramLaunchSettings >> program [
	^ program
]

{ #category : #accessing }
PhideProgramLaunchSettings >> program: anObject [
	program := anObject
]

{ #category : #'as yet unclassified' }
PhideProgramLaunchSettings >> project [
	^ buildMode project
]

{ #category : #'as yet unclassified' }
PhideProgramLaunchSettings >> resolveProjectRelativePath: path [
	^ self project resolveProjectRelativePath: path
]

{ #category : #accessing }
PhideProgramLaunchSettings >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
PhideProgramLaunchSettings >> workingDirectory: anObject [
	workingDirectory := anObject
]
