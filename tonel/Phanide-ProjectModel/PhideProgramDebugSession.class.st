Class {
	#name : #PhideProgramDebugSession,
	#superclass : #PhideAbstractProgramLaunchSession,
	#instVars : [
		'programFileName',
		'workingDirectory',
		'commandLineArguments',
		'environmentVariables',
		'stderrHandlingBlock',
		'stdoutHandlingBlock',
		'debuggerStderrHandlingBlock',
		'debuggerStdoutHandlingBlock',
		'finishedHandlingBlock',
		'currentStopPoint'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #testing }
PhideProgramDebugSession class >> isAbstract [
	^ self == PhideProgramDebugSession
]

{ #category : #accessing }
PhideProgramDebugSession >> commandLineArguments [
	^ commandLineArguments
]

{ #category : #accessing }
PhideProgramDebugSession >> commandLineArguments: anObject [
	commandLineArguments := anObject
]

{ #category : #accessing }
PhideProgramDebugSession >> currentStopPoint [
	^ currentStopPoint value
]

{ #category : #accessing }
PhideProgramDebugSession >> currentStopPoint: aStopPoint [
	currentStopPoint value: aStopPoint
]

{ #category : #'debug actions' }
PhideProgramDebugSession >> debugContinue [
]

{ #category : #'debug actions' }
PhideProgramDebugSession >> debugPause [
]

{ #category : #'debug actions' }
PhideProgramDebugSession >> debugStepInto [
]

{ #category : #'debug actions' }
PhideProgramDebugSession >> debugStepOver [
]

{ #category : #'debug actions' }
PhideProgramDebugSession >> debugStop [
]

{ #category : #accessing }
PhideProgramDebugSession >> environmentVariables [
	^ environmentVariables
]

{ #category : #accessing }
PhideProgramDebugSession >> environmentVariables: anObject [
	environmentVariables := anObject
]

{ #category : #accessing }
PhideProgramDebugSession >> finishedHandlingBlock [
	^ finishedHandlingBlock
]

{ #category : #initialization }
PhideProgramDebugSession >> initialize [
	super initialize.
	stdoutHandlingBlock := [ :v | ].
	stderrHandlingBlock := [ :v | ].
	debuggerStdoutHandlingBlock := [ :v | ].
	debuggerStderrHandlingBlock := [ :v | ].
	finishedHandlingBlock := [ :v | ].
	currentStopPoint := nil asValueHolder.
]

{ #category : #enumerating }
PhideProgramDebugSession >> onDebuggerStderrMessageDo: aBlock [
	debuggerStderrHandlingBlock := aBlock
]

{ #category : #enumerating }
PhideProgramDebugSession >> onDebuggerStdoutMessageDo: aBlock [
	debuggerStdoutHandlingBlock := aBlock
]

{ #category : #enumerating }
PhideProgramDebugSession >> onStderrMessageDo: aBlock [
	stderrHandlingBlock := aBlock
]

{ #category : #enumerating }
PhideProgramDebugSession >> onStdoutMessageDo: aBlock [
	stdoutHandlingBlock := aBlock
]

{ #category : #accessing }
PhideProgramDebugSession >> programFileName [
	^ programFileName
]

{ #category : #accessing }
PhideProgramDebugSession >> programFileName: anObject [
	programFileName := anObject
]

{ #category : #pipes }
PhideProgramDebugSession >> receiveDebuggerStderrMessage: message [
	debuggerStderrHandlingBlock value: message
]

{ #category : #pipes }
PhideProgramDebugSession >> receiveDebuggerStdoutMessage: message [
	debuggerStdoutHandlingBlock value: message
]

{ #category : #pipes }
PhideProgramDebugSession >> receiveStderrMessage: message [
	stderrHandlingBlock value: message
]

{ #category : #pipes }
PhideProgramDebugSession >> receiveStdoutMessage: message [
	stderrHandlingBlock value: message
]

{ #category : #enumerating }
PhideProgramDebugSession >> whenFinishedDo: aBlock [
]

{ #category : #accessing }
PhideProgramDebugSession >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
PhideProgramDebugSession >> workingDirectory: anObject [
	workingDirectory := anObject
]
