"
I represent a external subprocess.
"
Class {
	#name : #PhanideProcess,
	#superclass : #Object,
	#instVars : [
		'driver',
		'handle',
		'exitCode',
		'finishedCondition',
		'mutex',
		'pipes'
	],
	#pools : [
		'LibPhanidePool'
	],
	#category : 'Phanide-Bindings-Driver'
}

{ #category : #'instance creation' }
PhanideProcess class >> newWithDriver: driver handle: handle flags: flags [
	^ self basicNew initializeWithDriver: driver handle: handle flags: flags
]

{ #category : #events }
PhanideProcess >> destroy [
	handle ifNil: [ ^ self ].
	mutex critical: [ 
		handle destroy.
		handle := nil.
	].

]

{ #category : #accessing }
PhanideProcess >> driver [
	^ driver
]

{ #category : #accessing }
PhanideProcess >> extraStderr [
	^ pipes at: PHANIDE_PIPE_INDEX_EXTRA_STDERR + 1
]

{ #category : #accessing }
PhanideProcess >> extraStdin [
	^ pipes at: PHANIDE_PIPE_INDEX_EXTRA_STDIN + 1
]

{ #category : #accessing }
PhanideProcess >> extraStdout [
	^ pipes at: PHANIDE_PIPE_INDEX_EXTRA_STDOUT + 1
]

{ #category : #events }
PhanideProcess >> finish [
	self wait.
	self destroy.
]

{ #category : #events }
PhanideProcess >> finishedWithExitCode: anExitCode [
	mutex critical: [
		exitCode := anExitCode.
		finishedCondition signal.
		pipes do: [ :pipe | pipe processFinished]
	].

]

{ #category : #accessing }
PhanideProcess >> handle [
	^ handle
]

{ #category : #initialization }
PhanideProcess >> initializeWithDriver: aDriver handle: aHandle flags: flags [
	driver := aDriver.
	handle := aHandle.
	mutex := Semaphore forMutualExclusion.
	finishedCondition := PhanideConditionVariable new.
	pipes := {
		"stdin" PhanideProcessWritePipe forProcess: self index: 0 .
		"stdout" PhanideProcessReadPipe forProcess: self index: 1 .
		"stderr" PhanideProcessReadPipe forProcess: self index: 2
	}.
	(flags anyMask: PHANIDE_SPAWN_FLAGS_OPEN_EXTRA_PIPES) ifTrue: [ 
		pipes := pipes , {
			"extra stdin" PhanideProcessWritePipe forProcess: self index: 3 .
			"extra stdout" PhanideProcessReadPipe forProcess: self index: 4 .
			"extra stderr" PhanideProcessReadPipe forProcess: self index: 5
		}.
	]
]

{ #category : #events }
PhanideProcess >> signalPipe: pipeIndex [
	(pipes at: pipeIndex + 1) signal
]

{ #category : #accessing }
PhanideProcess >> stderr [
	^ pipes at: PHANIDE_PIPE_INDEX_STDERR + 1
]

{ #category : #accessing }
PhanideProcess >> stdin [
	^ pipes at: PHANIDE_PIPE_INDEX_STDIN + 1
]

{ #category : #accessing }
PhanideProcess >> stdout [
	^ pipes at: PHANIDE_PIPE_INDEX_STDOUT + 1
]

{ #category : #waiting }
PhanideProcess >> wait [
	exitCode ifNotNil: [ ^ exitCode ].
	mutex critical: [
		[exitCode] whileNil: [ 
			finishedCondition wait: mutex
		].
	
		^ exitCode
	]
]
