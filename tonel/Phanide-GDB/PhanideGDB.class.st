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
		'pendingCommandsMutex'
	],
	#category : 'Phanide-GDB-FrontEnd'
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

{ #category : #accessing }
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

{ #category : #accessing }
PhanideGDB >> start [
	process := PhanideDriver uniqueInstance spawnShell: self gdbCommand.
	session := Smalltalk session.
	
	mutex := Semaphore forMutualExclusion.
	pendingCommands := Dictionary new.
	pendingCommandsMutex := Semaphore forMutualExclusion.

	outputReadingProcess := self startOutputReadingProcess.
	
	stdin := process stdin textStream.
	self initializeGDBMI
]

{ #category : #'as yet unclassified' }
PhanideGDB >> startOutputReadingProcess [
	^ [
		self outputReadingProcessEntry
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
]

{ #category : #visiting }
PhanideGDB >> visitLogStreamRecord: record [
	eventHandler onLogOutput: record value
]

{ #category : #visiting }
PhanideGDB >> visitNotifyAsyncOutput: record [
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
]

{ #category : #visiting }
PhanideGDB >> visitTargetStreamRecord: record [
	eventHandler onTargetOutput: record value
]
