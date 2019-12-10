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
		'separateStdoutFromStderr'
	],
	#pools : [
		'LibPhanidePool'
	],
	#category : #'Phanide-GDB-FrontEnd'
}

{ #category : #commands }
PhanideGDB >> cli: aString [
	^ self cli: aString withResult: self newFutureCommandResult
]

{ #category : #commands }
PhanideGDB >> cli: aString withResult: aPhanideGDBFutureCommandResult [
	stdin nextPutAll: aPhanideGDBFutureCommandResult token asString; space; nextPutAll: aString; lf.
	^ aPhanideGDBFutureCommandResult
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
PhanideGDB >> execRun [
	^ self mi: '-exec-run'
]

{ #category : #accessing }
PhanideGDB >> gdbCommand [
	^ 'gdb -q --interpreter=mi'
	
]

{ #category : #initialization }
PhanideGDB >> initialize [
	super initialize.
	eventHandler := PhanideGDBTranscriptOutputEventHandler new.
	
	tokenCountMutex := Semaphore forMutualExclusion.
	tokenCount := 0.
	
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
	arguments ifEmpty: [ ^ self ].
	^ self mi: (ByteString streamContents: [:out |
		out nextPutAll: '-exec-arguments'.
		arguments do: [ :arg |
			out space.
			arg asCStringForGDBInto: out
		].
	])
]

{ #category : #'convenience commands' }
PhanideGDB >> setProgramFileAndSymbols: programFileName [
	^ self mi: ('-file-exec-and-symbols {1}' format: {programFileName asCStringForGDB})
]

{ #category : #'convenience commands' }
PhanideGDB >> setupLocalIORedirection [
	self separateStdoutFromStderr ifTrue: [ 
		^ self cli: 'set exec-wrapper <&3 >&4 2>&5'
	] ifFalse: [ 
		^ self cli: 'set exec-wrapper <&3 >&4 2>&4'
	]

]

{ #category : #commands }
PhanideGDB >> start [
	| programStdin |
	process := PhanideDriver uniqueInstance spawnShell: self gdbCommand flags: PHANIDE_SPAWN_FLAGS_OPEN_EXTRA_PIPES.
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

{ #category : #visiting }
PhanideGDB >> visitConsoleStreamRecord: record [
	eventHandler onConsoleOutput: record value
]

{ #category : #visiting }
PhanideGDB >> visitEndRecord: record [
]

{ #category : #visiting }
PhanideGDB >> visitExecAsyncOutput: record [
	Transcript show: 'TODO: Handle exec async output'; cr; show: record
]

{ #category : #visiting }
PhanideGDB >> visitLogStreamRecord: record [
	eventHandler onLogOutput: record value
]

{ #category : #visiting }
PhanideGDB >> visitNotifyAsyncOutput: record [
	Transcript show: 'TODO: Handle notify async output'; cr; show: record
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
	Transcript show: 'TODO: Handle status async output'; cr; show: record
]

{ #category : #visiting }
PhanideGDB >> visitTargetStreamRecord: record [
	eventHandler onTargetOutput: record value
]

{ #category : #'convenience commands' }
PhanideGDB >> workingDirectory: workingDirectory [
	^ self mi: ('-environment-cd {1}' format: {workingDirectory asCStringForGDB})
]
