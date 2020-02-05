"
I am a GDB client.

I use the the phanide driver for pipe IO that does not stop the image.
"
Class {
	#name : #PhanideGDB,
	#superclass : #Object,
	#instVars : [
		'process',
		'session',
		'mutex',
		'outputReadingProcess',
		'stdin',
		'eventHandler',
		'tokenCountMutex',
		'tokenCount',
		'pendingCommands',
		'pendingCommandsMutex',
		'programOutputReadingProcess',
		'programErrorReadingProcess',
		'separateStdoutFromStderr',
		'useIORedirection',
		'isRunning',
		'isStopped',
		'isStoppingForCommand'
	],
	#classVars : [
		'AsyncExecHandlingMap',
		'AsyncNotificationHandlingMap'
	],
	#pools : [
		'LibOSIOEventsPool'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #'class initialization' }
PhanideGDB class >> initialize [
	AsyncNotificationHandlingMap := Dictionary newFromPairs: #(
		'breakpoint-modified' onBreakpointModifiedNotification:
		'library-loaded' onLibraryLoadedNotification:
		'library-unloaded' onLibraryUnloadedNotification:
		'thread-group-added' onThreadGroupAddredNotification:
		'thread-group-started' onThreadGroupStartedNotification:
		'thread-group-exited' onThreadGroupExitedNotification:
		'thread-created' onThreadCreatedNotification:
		'thread-exited' onThreadExitedNotification:
		'thread-selected' onThreadSelectedNotification:
	).
	
	AsyncExecHandlingMap := Dictionary newFromPairs: #(
		running onExecRunningEvent:
		stopped onExecStoppedEvent:
	).
]

{ #category : #commands }
PhanideGDB >> cli: aString [
	^ self cli: aString withResult: self newFutureCommandResult
]

{ #category : #commands }
PhanideGDB >> cli: aString withResult: aPhanideGDBFutureCommandResult [
	stdin nextPutAll: aPhanideGDBFutureCommandResult token asString; space; nextPutAll: aString; lf.
	^ aPhanideGDBFutureCommandResult
]

{ #category : #'convenience commands' }
PhanideGDB >> createBreakpointInFile: fileName atLine: line [
	| breakpointCommand |
	breakpointCommand := self ensureStopped: [ 
		self mi: ('-break-insert --source {1} --line {2}' format: {fileName asCStringForGDB . line asString})
	].

	^ PhanideGDBBreakpoint for: self from: breakpointCommand results
]

{ #category : #events }
PhanideGDB >> dispatchEvent: event [
	^ eventHandler dispatchEvent: event
]

{ #category : #'as yet unclassified' }
PhanideGDB >> ensureStopped: aBlock [
	(isRunning or: [isStoppingForCommand]) ifFalse: [ ^ aBlock value ].
	isStoppingForCommand := true.
	(self mi: '-exec-interrupt') value.
	^ [ 
		aBlock value.
	] ensure: [
		isStoppingForCommand := false.
		(self mi: '-exec-continue') value.
	]
]

{ #category : #accessing }
PhanideGDB >> eventHandler [
	^ eventHandler
]

{ #category : #accessing }
PhanideGDB >> eventHandler: anObject [
	eventHandler := anObject
]

{ #category : #'convenience commands' }
PhanideGDB >> execContinue [
	^ self mi: '-exec-continue'
]

{ #category : #'convenience commands' }
PhanideGDB >> execInterrupt [
	^ self mi: '-exec-interrupt'
]

{ #category : #'convenience commands' }
PhanideGDB >> execNext [
	^ self mi: '-exec-next'
]

{ #category : #'convenience commands' }
PhanideGDB >> execRun [
	^ self mi: '-exec-run'
]

{ #category : #'convenience commands' }
PhanideGDB >> execStep [
	^ self mi: '-exec-step'
]

{ #category : #private }
PhanideGDB >> finishProcessExecution [
	process finish.
	outputReadingProcess ifNotNil: [ outputReadingProcess terminate ].
	programOutputReadingProcess ifNotNil: [ programOutputReadingProcess terminate ].
	programErrorReadingProcess ifNotNil: [ programErrorReadingProcess terminate ].
]

{ #category : #accessing }
PhanideGDB >> gdbCommand [
	^ 'gdb -q --interpreter=mi'
	
]

{ #category : #'convenience commands' }
PhanideGDB >> getLocalsInThread: threadId frameLevel: frameLevel [
	| variables |
	variables := (self mi: ('-stack-list-variables --thread {1} --frame {2} --simple-values' format: {threadId asString . frameLevel asString})) results.
	^ (variables at: #variables) collect: [ :var | PhanideGDBVariable for: self from: var ]
]

{ #category : #'convenience commands' }
PhanideGDB >> getStackTraceForThread: threadId [
	| trace frames |
	trace := (self mi: ('-stack-list-frames --thread {1}' format: {threadId asString})) results at: #stack.
	frames := trace collect: [ :frame |
		self assert: frame key = #frame.
		(PhanideGDBStackFrame for: self from: frame value)
			thread: threadId
	].
	^ frames
]

{ #category : #initialization }
PhanideGDB >> initialize [
	super initialize.
	eventHandler := PhanideGDBTranscriptOutputEventHandler new.
	
	tokenCountMutex := Semaphore forMutualExclusion.
	tokenCount := 0.
	isRunning := false.
	isStoppingForCommand := false.
]

{ #category : #initialization }
PhanideGDB >> initializeGDBMI [
	"Enable the async mode."
	stdin nextPutAll: '-gdb-set mi-async on'; lf
]

{ #category : #commands }
PhanideGDB >> mi: aString [
	^ self mi: aString withResult: self newFutureCommandResult
]

{ #category : #commands }
PhanideGDB >> mi: aString withResult: aPhanideGDBFutureCommandResult [
	stdin nextPutAll: aPhanideGDBFutureCommandResult token asString; nextPutAll: aString; lf.
	^ aPhanideGDBFutureCommandResult
]

{ #category : #private }
PhanideGDB >> newFutureCommandResult [
	| token result |
	token := self newToken.
	result := PhanideGDBFutureCommandResult new token: token.
	pendingCommandsMutex critical: [ 
		pendingCommands at: token put: result
	].
	^ result
]

{ #category : #private }
PhanideGDB >> newToken [
	| result |
	tokenCountMutex critical: [ 
		result := (tokenCount := tokenCount + 1).
	].
	^ result
	
]

{ #category : #notifications }
PhanideGDB >> onBreakpointModifiedNotification: notificationData [
]

{ #category : #events }
PhanideGDB >> onExecRunningEvent: eventData [
	isRunning := true.
	^ self dispatchEvent: (PhanideGDBExecRunningEvent for: self with: eventData)
]

{ #category : #events }
PhanideGDB >> onExecStoppedEvent: eventData [
	isStoppingForCommand ifTrue: [ ^ self ].
	isStopped := true.
	^ self dispatchEvent: (PhanideGDBExecStoppedEvent for: self with: eventData)

]

{ #category : #notifications }
PhanideGDB >> onLibraryLoadedNotification: notificationData [
]

{ #category : #notifications }
PhanideGDB >> onLibraryUnloadedNotification: notificationData [
]

{ #category : #notifications }
PhanideGDB >> onThreadCreatedNotification: notificationData [
]

{ #category : #notifications }
PhanideGDB >> onThreadExitedNotification: notificationData [
]

{ #category : #notifications }
PhanideGDB >> onThreadGroupAddredNotification: notificationData [
]

{ #category : #notifications }
PhanideGDB >> onThreadGroupExitedNotification: notificationData [
]

{ #category : #notifications }
PhanideGDB >> onThreadGroupStartedNotification: notificationData [
]

{ #category : #notifications }
PhanideGDB >> onThreadSelectedNotification: notificationData [
]

{ #category : #'as yet unclassified' }
PhanideGDB >> outputReadingProcessEntry [
	| stdout line |
	stdout := process stdout textStream.
	[(line := stdout nextLine)] whileNotNil: [ 
		self processOutputLine: line.
	]

]

{ #category : #'as yet unclassified' }
PhanideGDB >> processOutputLine: line [
	| record |
	record := PhanideGDBOutputParser parse: line.
	record isPetitFailure ifTrue: [
		^ [
			self error: 'Failed to parse gdb output record: ' , line printString
		] fork
	].

	record accept: self
]

{ #category : #'as yet unclassified' }
PhanideGDB >> programErrorOutputReadingProcess [
	| stderr line |
	stderr := process extraStderr textStream.
	self flag: 'FIXME: Do not read per line here.'.
	[(line := stderr nextLine)] whileNotNil: [ 
		eventHandler onTargetErrorOutput: line; onTargetErrorOutput: String cr.
	]

]

{ #category : #'as yet unclassified' }
PhanideGDB >> programOutputReadingProcess [
	| stdout line |
	stdout := process extraStdout textStream.
	self flag: 'FIXME: Do not read per line here.'.
	[(line := stdout nextLine)] whileNotNil: [ 
		eventHandler onTargetOutput: line; onTargetOutput: String cr
	]

]

{ #category : #'convenience commands' }
PhanideGDB >> quit [
	self mi: '-gdb-exit'.
	^ self finishProcessExecution
]

{ #category : #accessing }
PhanideGDB >> separateStdoutFromStderr [
	^ separateStdoutFromStderr ifNil: [ separateStdoutFromStderr := false ]
]

{ #category : #accessing }
PhanideGDB >> separateStdoutFromStderr: aBoolean [
	^ separateStdoutFromStderr := aBoolean
]

{ #category : #'convenience commands' }
PhanideGDB >> setProgramArguments: arguments [
	^ self mi: (ByteString streamContents: [:out |
		out nextPutAll: '-exec-arguments'.
		arguments do: [ :arg |
			out space.
			arg asCStringForGDBInto: out
		].
	
		self useIORedirection ifTrue: [
			self separateStdoutFromStderr ifTrue: [ 
				out nextPutAll: ' <&3 >&4 2>&5'
			] ifFalse: [ 
				out nextPutAll: ' <&3 >&4 2>&4'
			]
		].
	])
]

{ #category : #'convenience commands' }
PhanideGDB >> setProgramFileAndSymbols: programFileName [
	^ self mi: ('-file-exec-and-symbols {1}' format: {programFileName asCStringForGDB})
]

{ #category : #commands }
PhanideGDB >> start [
	| programStdin |
	process := OSIOEventsDriver uniqueInstance spawnShell: self gdbCommand flags: OS_IOEVENTS_SPAWN_FLAGS_OPEN_EXTRA_PIPES.
	session := Smalltalk session.
	
	mutex := Semaphore forMutualExclusion.
	pendingCommands := Dictionary new.
	pendingCommandsMutex := Semaphore forMutualExclusion.

	outputReadingProcess := self startOutputReadingProcess.
	programOutputReadingProcess := self startProgramOutputReadingProcess.
	self separateStdoutFromStderr ifTrue: [ 
		programErrorReadingProcess := self startProgramErrorOutputReadingProcess.
	].
	
	stdin := process stdin textStream.
	programStdin := process extraStdin textStream.
	self initializeGDBMI
]

{ #category : #'as yet unclassified' }
PhanideGDB >> startOutputReadingProcess [
	^ [
		self outputReadingProcessEntry
	] fork
]

{ #category : #'as yet unclassified' }
PhanideGDB >> startProgramErrorOutputReadingProcess [
	^ [
		self programErrorOutputReadingProcess
	] fork
]

{ #category : #'as yet unclassified' }
PhanideGDB >> startProgramOutputReadingProcess [
	^ [
		self programOutputReadingProcess
	] fork
]

{ #category : #accessing }
PhanideGDB >> useIORedirection [
	^ useIORedirection ifNil: [ useIORedirection := true ]
]

{ #category : #accessing }
PhanideGDB >> useIORedirection: anObject [
	useIORedirection := anObject
]

{ #category : #visiting }
PhanideGDB >> visitConsoleStreamRecord: record [
	eventHandler onConsoleOutput: record value
]

{ #category : #visiting }
PhanideGDB >> visitEndRecord: record [
]

{ #category : #visiting }
PhanideGDB >> visitExecAsyncOutput: record [
	| asyncClass data selector |
	asyncClass := record asyncClass.
	data := record results.
	
	selector := AsyncExecHandlingMap at: asyncClass ifAbsent: [
		eventHandler onLogOutput:(ByteString streamContents: [:out |
			out nextPutAll: 'Unsupported async exec event from gdb:'; cr.
			out nextPutAll: asyncClass; space; print: data; cr.
		]).
		^ self
	].

	^ self perform: selector with: data
]

{ #category : #visiting }
PhanideGDB >> visitLogStreamRecord: record [
	eventHandler onLogOutput: record value
]

{ #category : #visiting }
PhanideGDB >> visitNotifyAsyncOutput: record [
	| asyncClass data selector |
	asyncClass := record asyncClass.
	data := record results.
	
	selector := AsyncNotificationHandlingMap at: asyncClass ifAbsent: [
		eventHandler onLogOutput:(ByteString streamContents: [:out |
			out nextPutAll: 'Unsupported async notfication from gdb:'; cr.
			out nextPutAll: asyncClass; space; print: data; cr.
		]).
		^ self
	].

	^ self perform: selector with: data
]

{ #category : #visiting }
PhanideGDB >> visitResultRecord: record [
	| tokenValue |
	record token ifNil: [ ^ self ].
	
	tokenValue := record token asInteger.
	pendingCommandsMutex critical: [
		pendingCommands at: tokenValue ifPresent: [ :result |
			pendingCommands removeKey: tokenValue.
			result value: record
		].
	].
]

{ #category : #visiting }
PhanideGDB >> visitStatusAsyncOutput: record [
	Transcript show: 'TODO: Handle status async output'; cr; show: record; cr.
]

{ #category : #visiting }
PhanideGDB >> visitTargetStreamRecord: record [
	eventHandler onTargetOutput: record value
]

{ #category : #'convenience commands' }
PhanideGDB >> workingDirectory: workingDirectory [
	^ self mi: ('-environment-cd {1}' format: {workingDirectory asCStringForGDB})
]
