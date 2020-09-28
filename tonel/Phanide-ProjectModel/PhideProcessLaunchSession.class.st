Class {
	#name : #PhideProcessLaunchSession,
	#superclass : #PhideAbstractProgramLaunchSession,
	#instVars : [
		'shellCommand',
		'process',
		'session',
		'mutex',
		'outputReadingProcess',
		'stdin',
		'stdoutHandlingBlock',
		'stderrHandlingBlock',
		'errorReadingProcess',
		'finishedHandlingBlock'
	],
	#category : #'Phanide-ProjectModel'
}

{ #category : #accessing }
PhideProcessLaunchSession >> errorReadingProcessEntry [
	| stderr message |
	stderr := process stderr textStream.
	[(message := stderr next: 4096) size > 0] whileTrue: [ 
		stderrHandlingBlock value: message
	]

]

{ #category : #initialization }
PhideProcessLaunchSession >> initialize [
	super initialize.
	stdoutHandlingBlock := [ :v | ].
	stderrHandlingBlock := [ :v | ].
	finishedHandlingBlock := [ :v | ].
]

{ #category : #actions }
PhideProcessLaunchSession >> isRunning [
	^ session == Smalltalk session and: [ process isNotNil and: [ process isRunning ]]
]

{ #category : #enumerating }
PhideProcessLaunchSession >> onStderrMessageDo: aBlock [
	stderrHandlingBlock := aBlock
]

{ #category : #enumerating }
PhideProcessLaunchSession >> onStdoutMessageDo: aBlock [
	stdoutHandlingBlock := aBlock
]

{ #category : #accessing }
PhideProcessLaunchSession >> outputReadingProcessEntry [
	| stdout message |
	stdout := process stdout textStream.
	[(message := stdout next: 4096) size > 0] whileTrue: [ 
		stdoutHandlingBlock value: message
	]

]

{ #category : #enumerating }
PhideProcessLaunchSession >> sendMessageToStdin: message [
	stdin ifNotNil: [
		stdin nextPutAll: message
	]
]

{ #category : #accessing }
PhideProcessLaunchSession >> shellCommand [
	^ shellCommand
]

{ #category : #accessing }
PhideProcessLaunchSession >> shellCommand: anObject [
	shellCommand := anObject
]

{ #category : #'as yet unclassified' }
PhideProcessLaunchSession >> shellCommand: buildCommand inWorkingDirectory: workingDirectory [
	self shellCommand: ('cd "{1}" && {2}' format: {workingDirectory . buildCommand})
]

{ #category : #'as yet unclassified' }
PhideProcessLaunchSession >> spawnProcess [
	^ OSIOEventsDriver uniqueInstance spawnShell: shellCommand
]

{ #category : #accessing }
PhideProcessLaunchSession >> start [
	process := self spawnProcess.
	session := Smalltalk session.
	mutex := Semaphore forMutualExclusion.
	outputReadingProcess := self startOutputReadingProcess.
	errorReadingProcess := self startErrorReadingProcess.
	stdin := process stdin textStream.
]

{ #category : #accessing }
PhideProcessLaunchSession >> startErrorReadingProcess [
	^ [
		self errorReadingProcessEntry
	] fork
]

{ #category : #accessing }
PhideProcessLaunchSession >> startOutputReadingProcess [
	^ [
		self outputReadingProcessEntry
	] fork
]

{ #category : #actions }
PhideProcessLaunchSession >> terminate [
	outputReadingProcess ifNotNil: [
		outputReadingProcess terminate
	].
	errorReadingProcess ifNotNil: [
		errorReadingProcess terminate
	].
	process ifNotNil: [
		process
			terminate;
			wait.
		process := nil
	].

]

{ #category : #enumerating }
PhideProcessLaunchSession >> whenFinishedDo: aBlock [
	finishedHandlingBlock := aBlock
]
