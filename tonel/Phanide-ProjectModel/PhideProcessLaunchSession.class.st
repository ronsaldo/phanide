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
	self assert: self startInTTY not.
	stderr := process stderr.
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
	stdout := process stdout.
	[(message := stdout next: 4096) size > 0] whileTrue: [ 
		stdoutHandlingBlock value: message
	]

]

{ #category : #enumerating }
PhideProcessLaunchSession >> sendMessageToStdin: message [
	stdin ifNotNil: [
		stdin nextPutAll: message utf8Encoded
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
PhideProcessLaunchSession >> shellCommand: command inWorkingDirectory: workingDirectory [
	| template |
	template := 'cd "{1}" && {2}'.
	Smalltalk os isUnix ifTrue: [
		"Remove the (DY)?LD_LIBRARY_PATH environment variables that are set by the pharo bash script."
		template := 'unset LD_LIBRARY_PATH && unset DYLD_LIBRARY_PATH && ' , template
	].
	self shellCommand: (template format: {workingDirectory . command})
]

{ #category : #'as yet unclassified' }
PhideProcessLaunchSession >> spawnProcess [
	^ self startInTTY
		ifTrue: [OSIOEventsDriver uniqueInstance spawnShellTTY: shellCommand]
		ifFalse: [OSIOEventsDriver uniqueInstance spawnShell: shellCommand]
]

{ #category : #accessing }
PhideProcessLaunchSession >> start [
	process := self spawnProcess.
	session := Smalltalk session.
	mutex := Semaphore forMutualExclusion.
	mutex critical: [ 
		outputReadingProcess := self startOutputReadingProcess.
		errorReadingProcess := self startErrorReadingProcess.
		stdin := process stdin.
	].

]

{ #category : #accessing }
PhideProcessLaunchSession >> startErrorReadingProcess [
	self startInTTY ifTrue: [ ^ nil ].
	^ [
		self errorReadingProcessEntry
	] fork
]

{ #category : #'as yet unclassified' }
PhideProcessLaunchSession >> startInTTY [
	^ true
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
		outputReadingProcess terminate.
		outputReadingProcess := nil
	].
	errorReadingProcess ifNotNil: [
		errorReadingProcess terminate.
		errorReadingProcess := nil.
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
